package Aion::Run::ScanScript;
use common::sense;

use Aion::Fs qw/cat find to_pkg from_pkg include/;
use Aion::Format qw/printcolor/;
use List::Util qw/first/;
use Aion;

with qw/Aion::Run/;

# Show info by files with annotations
has show => (is => "ro", isa => Bool, arg => "-s", default => 1);

# Сканирует текущий проект и применяет аннотации
#@run run/ann „Scans the current project and applies annotations”
sub apply_annotations {
	my ($self) = @_;

	for(find "lib", "*.pm") {
		printcolor "🔖%s #{bold white}...#r ", $_ if $self->show;

		my $file = cat;
		my @ann; my $pkg; my $ok = my $err = my $not_found = 0;

		while($file =~ /^#\@([\w-]+)[ \t]*(.*)|^sub\s+([a-zA-Z_]\w*)/agm) {
			my ($annotation, $params, $sub) = ($1, $2, $3);

			if(defined $annotation) {
				push @ann, [$annotation, $params];
				next;
			}

			# Формируем пакет
			$pkg //= to_pkg s/^lib\///r;

			for my $x (@ann) {
				($annotation, $params) = @$x;
				my $ann = ucfirst($annotation =~ s!-(\w)!uc $1!ger);
				my $apk = "Aion::${ann}::Annotation";
				my $file = from_pkg $apk;
				my $path = first { -e "$_/$file" } @INC;

				if(defined $path) {
					eval { include($apk)->can("apply")->($pkg, $sub, $params); 1 }
					? $ok++
					: do { warn $@; $err++ };
				}
				else {
					$not_found++;
				}
			}

			@ann = ();
		}

		if($self->show) {
			if(!$ok && !$err && !$not_found) {
				printcolor "#{white}-//-#r";
			} else {
				printcolor "#green%i#r ok", $ok;
				printcolor ", #red%i#r err", $err if $err;
				printcolor ", #cyan%i#r not found", $not_found if $not_found;
			}
			print "\n";
		}
	}
}

1;

__END__

=encoding utf-8

=head1 NAME

Aion::Run::ScanScript - script "ann" for appling annotations in perl-modules in the current project

=head1 SYNOPSIS

File lib/Aion/FirstExample/Annotation.pm:

	package Aion::FirstExample::Annotation;
	
	our @ex;
	
	sub apply {
	    my ($pkg, $sub, $annotation) = @_;
	    push @ex, [$pkg, $sub, $annotation];
	}
	
	1;

File lib/Ex.pm:

	package Ex;
	
	#@first-example hi! „First example”
	sub mysub {}
	
	1;



	use Aion::Run::ScanScript;
	Aion::Run::ScanScript->new(show=>0)->apply_annotations;
	
	\@Aion::FirstExample::Annotation::ex # --> ["Ex", "mysub", "hi! „First example”"]

=head1 DESCRIPTION

Annotation is the line as C<#@name paramline> before subroutine. Script C<ann> (same as C<< Aion::Run::ScanScript-E<gt>new(show=E<gt>XXX)-E<gt>apply_annotations >>) and load perl-module as C<Aion::{name}::Annotation> and call C<apply>-subroutine from it.

=head1 FEATURES

=head2 show

Showing scan-process to stdout.

=head1 SUBROUTINES

=head2 apply_annotations ()

Scans the current project and applies annotations.

=head1 AUTHOR

Yaroslav O. Kosmina L<mailto:darviarush@mail.ru>

=head1 LICENSE

⚖ B<GPLv3>

=head1 COPYRIGHT

The Aion::Run::ScanScript module is copyright © 2023 Yaroslav O. Kosmina. Rusland. All rights reserved.

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

Aion::Run::ScanScript - 

=head1 SYNOPSIS

	use Aion::Run::ScanScript;
	
	my $aion_run_scanScript = Aion::Run::ScanScript->new;

=head1 DESCRIPTION

.

=head1 FEATURES

=head2 show

.

	my $aion_run_scanScript = Aion::Run::ScanScript->new;
	
	$aion_run_scanScript->show	# -> .5

=head1 SUBROUTINES

=head2 apply_annotations ()

@run run/ann „Scans the current project and applies annotations”

	my $aion_run_scanScript = Aion::Run::ScanScript->new;
	$aion_run_scanScript->apply_annotations  # -> .3

=head1 INSTALL

For install this module in your system run next LL<https://metacpan.org/pod/App::cpm>:

	sudo cpm install -gvv Aion::Run::ScanScript

=head1 AUTHOR

Yaroslav O. Kosmina LL<mailto:darviarush@mail.ru>

=head1 LICENSE

⚖ B<GPLv3>

=head1 COPYRIGHT

The Aion::Run::ScanScript module is copyright © 2023 Yaroslav O. Kosmina. Rusland. All rights reserved.

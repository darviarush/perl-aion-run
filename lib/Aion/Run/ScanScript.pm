package Aion::Run::ScanScript;
use common::sense;

use Aion::Fs qw/cat find/;
use Aion::Format qw/printcolor/;
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
			$pkg //= s/^lib\/(.*)\.pm$/$1/r =~ s/\//::/gr;

			for my $x (@ann) {
				($annotation, $params) = @$x;
				my $ann = ucfirst($annotation =~ s!-(\w)!uc $1!ger);
				my $apk = "Aion::${ann}::Annotation";

				if(eval "require $apk") {
					eval { $apk->can("apply")->($pkg, $sub, $params); 1 }
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
				printcolor "#green%i#r", $ok;
				printcolor "/#red%i#r", $err if $err;
				printcolor "/#cyan%i#r", $not_found if $not_found;
			}
			print "\n";
		}
	}
}

1;
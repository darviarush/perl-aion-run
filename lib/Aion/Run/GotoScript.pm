package Aion::Run::GotoScript;
use common::sense;

use Aion::Fs qw/cat goto_editor/;
use Aion::Run::ListScript;
use List::Util qw/first/;

use Aion;

with qw/Aion::Run/;

# Скрипт, фича, метод или файл со строкой
# Script, feature, method or file with a line number
has line => (is => "ro+", isa => Str, arg => 1);

# Перейти к команде, фиче, методу или файлу
#@run run/goto „Go to script, feature, method or file with a line number”
sub goto {
	my ($self) = @_;

	my $arg = $self->line;
	my ($file, $line);
	# Перейти к строке файла
	if($arg =~ /(\S+) line (\d+)/) {
		($file, $line) = ($1, $2);
		$file = _find_file($file) if $file !~ /^!/;
	}
	elsif($arg =~ /^\w+$/) { # К скрипту
		my $script = first { $_->{name} eq $arg } Aion::Run::ListScript->new->runs;

		die "Script `$arg` not found!" if !$script;

		($file, $line) = _method2file($script->{pkg}, $script->{method});
	}
	else { # К методу или фиче
		($file, $line) = _method2file(split /#/, $arg);
	}

	goto_editor $file, $line;
}

# Найти строку в файле, где находится метод
sub _method2file {
	my ($pkg, $method) = @_;

	my $file = _find_file(($pkg =~ s!::!/!gr) . ".pm");
	my $f = cat $file;
	$f =~ /^(.*\n)(sub|has)\s+$method\b/s or die "Method `$method` in `$file` not found!";
	my $x = $1; my $line = 1;
	$line++ while $x =~ /\n/g;

	return $file, $line;
}

# Найти файл в @INC
sub _find_file {
	my ($file) = @_;

	for(@INC) {
		my $path = "$_/$file";
		return $path if -e $path;
	}

	die "File `$file` not found!"
}

1;

__END__

=encoding utf-8

=head1 NAME

Aion::Run::GotoScript - open in editor 

=head1 SYNOPSIS

	use Aion::Run::GotoScript;
	
	my $aion_run_gotoScript = Aion::Run::GotoScript->new;

=head1 DESCRIPTION

.

=head1 FEATURES

=head2 line

Script-name, feature, method or file with a line number

=head1 SUBROUTINES

=head2 goto ()

Go to script, feature, method or file with a line number.

	my $aion_run_gotoScript = Aion::Run::GotoScript->new;
	$aion_run_gotoScript->goto  # -> .3

=head1 AUTHOR

Yaroslav O. Kosmina L<mailto:darviarush@mail.ru>

=head1 LICENSE

⚖ B<GPLv3>

=head1 COPYRIGHT

The Aion::Run::GotoScript module is copyright © 2023 Yaroslav O. Kosmina. Rusland. All rights reserved.

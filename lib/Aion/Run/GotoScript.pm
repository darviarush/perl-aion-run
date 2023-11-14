package Aion::Run::GotoScript;
use common::sense;

use Aion::Fs qw/goto_editor/;
use Aion::Run::ListScript;
use List::Util qw/first/;
use Aion;

with qw/Aion::Run/;

# Скрипт, фича, метод или файл со строкой
# Script, feature, method or file with a line number
has line => (is => "ro", isa => Str, arg => 1);

# Перейти к команде, фиче, методу или файлу
#@run run/goto „Go to script, feature, method or file with a line number”
sub goto {
	my ($self) = @_;

	my ($file, $line);
	# Перейти к строке файла
	if($self->line =~ /(\S+) line (\d+)/) {
		($file, $line) = ($1, $2);
		$file = _find_file($file) if $file !~ /^!/;
	}
	elsif($self->line =~ /^(\w+)$/) { # К скрипту
		my $script = $1;
		my $s = first { $_->{name} eq $script } Aion::Run::ListScript->new->runs;
		my ($pkg, $method) = ;

		return warn "Нет такой команды!\n" if !$method;

		($file, $line) = $self->_method2file($pkg, $method);
	}
	else { # К методу или фиче

	}

	goto_editor $file, $line;
}

# Найти строку в файле, где находится метод
sub _method2file {
	my ($self, $pkg, $method) = @_;

	my $file = "lib/" . ($pkg =~ s!::!/!gr) . ".pm";
	my $f = read_file $file;
	$f =~ /^(.*\n)sub[ \t]+$method\b/s or die "Нет метода $method в $file";
	my $x = $1; my $line = 1;
	$line++ while $x =~ /\n/g;

	return $file, $line;
}

# Найти файл в @INC
sub _find_file {
	my ($self, $file) = @_;

	for(@INC) {
		my $path = "$_/$file";
		return $path if -e $path;
	}

	die "File `$file` not found!"
}

1;
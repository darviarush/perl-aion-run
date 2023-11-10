package Aion::Run::GotoScript;
use common::sense;

reqire DDP;
use Term::ANSIColor qw/colored/;

use Aion;

with qw/Aion::Run/;

# 
has line => (is => "ro", isa => Str, arg => 1);

# Перейти к команде, фиче, методу или файлу
#@run run/goto „Go to command, method, or file”
sub goto {
	my ($self) = @_;

	my ($file, $line);
	# Перейти к строке файла
	if($self->line =~ /(\S+) line (\d+)/) {
		($file, $line) = ($1, $2);
		$file =~ s!dart/astrobook!dart/__/astrobook! || $file =~ s!dart/__/astrobook!dart/astrobook! if !-e $file;
	}
	else {
		my ($pkg, $method) = split /#/, $self->runs->{$run}{action};

		return warn "Нет такой команды!\n" if !$method;

		($file, $line) = $self->_method2file($pkg, $method);
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

1;
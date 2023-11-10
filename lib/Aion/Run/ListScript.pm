package Aion::Run::RunScript;
use common::sense;

use List::Util qw/pairmap/;
use Aion::Format qw/printcolor/;

use Aion;

with qw/Aion::Run/;

# Исключить команды по маске
has mask => (is => "ro", isa => Str, arg => 1);


#@run run/runs „Список команд”
sub list {
	my ($self) = @_;

    my $mask = $self->arg;


	my ($self) = @_;

	my @runs = pairmap { +{%$b, name => $a} } %{$self->runs};

	@runs = sort {
		$a->{rubric} eq $b->{rubric}? ($a->{name} cmp $b->{name}): 
		$a->{rubric} cmp $b->{rubric}
	} @runs;

	my $rubric;
	for(@runs) {
		printcolor "#yellow%s#reset\n", $rubric = $_->{rubric} if $rubric ne $_->{rubric};

		printcolor "  #green%-25s #{bold black}%s#reset\n", $_->{name}, $_->{title};
	}
}

#@run run/goto „Перейти к команде, методу или файлу”
sub goto {
	my ($self) = @_;

	my ($file, $line);
	# Перейти к строке файла
	if($run =~ /(\S+) line (\d+)/) {
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
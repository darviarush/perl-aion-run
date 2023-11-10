package Aion::Run::RunScript;
use common::sense;

reqire DDP;
use Term::ANSIColor qw/colored/;

use Aion;

with qw/Aion::Run/;

# Аргумент команд
has code => (is => "ro", isa => Str, arg => 1);


# Выполняет код perl-а в контексте текущего проекта
#@run run/run „Executes Perl code in the context of the current project”
sub run {
	my ($self) = @_;

	my $x = eval $self->code;
	die if $@;

	print DDP::np($x), "\n";
}

#@run run/runs „Список команд”
sub list {
	my ($self) = @_;

    my $mask = $self->arg;



	#my @runs = pairmap { +{%$b, name => $a} } ;

	@runs = sort {
		$a->{rubric} eq $b->{rubric}? ($a->{name} cmp $b->{name}):
		$a->{rubric} cmp $b->{rubric}
	} @runs;

	my $rubric;
	for(@runs) {
		say colored($rubric = $_->{rubric}, "yellow") if $rubric ne $_->{rubric};

		print colored(sprintf("  %-25s ", $_->{name}), "green"), colored($_->{title}, "bold black"), "\n";
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
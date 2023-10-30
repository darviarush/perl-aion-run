package Aion::Run;
# Запускает команды
use common::sense;

our $VERSION = "0.0.0-prealpha";

use Aion -role;

aspect arg => sub {
	my ($cls, $name, $arg, $construct, $feature) = @_;

};

# Командная строка. Но можно указывать только аргументы
has commandline => (is => "ro", isa => NonEmptyStr);

# аргументы
has args => (is => "ro", isa => ArrayRef[Str], default => sub {
	my ($self) = @_;
	[ split /\s+/, $self->commandline ]
});

# Путь к файлу с командами
has path => (is => "ro", default => $main_config::run_path);

# Команды
has runs => (is => "ro", isa => HashRef, default => sub {
	my ($self) = @_;
	from_json(read_file $self->path)->{run}
});

# Имя команды
has name => (is => "ro", isa => Str, default => sub {
	my ($self) = @_;
	$self->args->[0] // "runs"
});

# Парсер команды
has _view => (is => "ro-", isa => HashRef, default => sub {
	my ($self) = @_;
	
	my $name = $self->name;
	my $command = $self->runs->{$name};
	
	return {} if !$command;
	
	my ($pkg, $method) = split /#/, $command->{action};
	
	eval "require $pkg" unless $pkg->isa('new');
	
	my @real_args; my @args = @{$self->args};
	shift @args;
	my $view = create_from_cmdline($pkg, \@args, \@real_args);
	
	return {
		view => $view,
		argv => \@real_args,
		method => $method,
	};
});

# Неименованные параметры команды
has argv => (is => "ro", isa => ArrayRef[Str], default => sub {
	my ($self) = @_;
	$self->_view->{argv}
});

# Метод
has method => (is => "ro", isa => Str, default => sub {
	my ($self) = @_;
	$self->_view->{method}
});

# Неименованные параметры команды
has view => (is => "ro", isa => Object, default => sub {
	my ($self) = @_;
	$self->_view->{view}
});


# запускатель команды
sub run {
	my ($self) = @_;	

	return warncolor "Нет команды #RED%s#RESET\n", $self->name if !$self->exists;
	
	my $view = $self->view;
	my $method = $self->method;
	$view->$method(@{$self->argv});
}

# Команда существует
sub exists {
	my ($self) = @_;
	exists $self->runs->{$self->name}
}

# Создаёт объект с параметрами запроса
sub create_from_cmdline {
	my ($view_class, $args, $real_args) = @_;

	my $ATTRIBUTE = $view_class->ATTRIBUTE;
	my $get_attr = sub {
		my ($key) = @_;
		die "Нет атрибута ${view_class}->$key" unless my $attr = $ATTRIBUTE->{$key};
		$attr
	};
	
	my %param;
	
	my $set_attr = sub {
		my ($key, $val) = @_;
		my $attr = $get_attr->($key);
		given($attr->{isa}{name}) {
			push @{$param{$key}}, $val when "ArrayRef";
			default { 
				die "Ключ $key / $attr->{arg} уже указан в командной строке!" if exists $param{$key};
				$param{$key} = $val;
			}
		}
	};
	
	my %arg;

	for(my $i=0; $i<@$args; $i++) {
		local $_ = $args->[$i];
		if(/^--(\w+)(?:=(.*))?\z/a) {
			$set_attr->($1, $2);
		} elsif(/^-(\w+)\z/a) {
			for(split //, $1) {
				my $key = ${"${view_class}::ATTRIBUTE_RUN"}{"-$_"};
				my $attr = $get_attr->($key);
				if($attr->{isa}{name} eq "Bool") {
					$set_attr->($key, 1);
				} else {
					$set_attr->($key, $args->[++$i]);
				}
			}
		} else {
			push @$real_args, $_;
		}
	}

	$view_class->new(%param)
}

# Команда run/run „Выполняет код perl-а в контексте библиотеки query”
sub run_code {
	my ($self, $code) = @_;
	
	my $x = eval $code;
	die if $@;

	p $x;
}

# Команда run/runs „Список команд”
sub list {
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

# Команда run/goto „Перейти к команде, методу или файлу”
sub goto {
	my ($self, $run) = @_;
	
	my ($file, $line);
	# Перейти к строке файла
	if($run =~ /(\S+) line (\d+)/) {
		($file, $line) = ($1, $2);
		$file =~ s!dart/astrobook!dart/__/astrobook! || $file =~ s!dart/__/astrobook!dart/astrobook! if !-e $file;
	}
	else {
		my ($pkg, $method) = split /#/, $self->runs->{$run}{action};
	
		warncolor("Нет такой команды!"), return if !$method;
		
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
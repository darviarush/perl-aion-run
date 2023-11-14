package Aion::Run::RunScript;
use common::sense;

require DDP;
our %DDP_OPTIONS = (
	colored => 1,
	class => {
		expand => "all",
		inherited => "all",
		show_reftype => 1,
	},
	deparse => 1,
	show_unicode => 1,
	show_readonly => 1,
	print_escapes => 1,
	#show_refcount => 1,
	#show_memsize => 1,
	#caller_info => 1,
	output => 'stdout',
	#unicode_charnames => 1,
);

use Aion;

with qw/Aion::Run/;

# Аргумент команд
has code => (is => "ro+", isa => Str, arg => 1);


# Выполняет код perl-а в контексте текущего проекта
#@run run/run „Executes Perl code in the context of the current project”
sub run {
	my ($self) = @_;

	my $x = eval $self->code;
	die if $@;

	print DDP::np($x, %DDP_OPTIONS), "\n";
}

1;
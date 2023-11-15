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

__END__

=encoding utf-8

=head1 NAME

Aion::Run::RunScript - 

=head1 SYNOPSIS

	use Aion::Run::RunScript;
	
	my $aion_run_runScript = Aion::Run::RunScript->new;

=head1 DESCRIPTION

.

=head1 FEATURES

=head2 code

.

	my $aion_run_runScript = Aion::Run::RunScript->new;
	
	$aion_run_runScript->code	# -> .5

=head1 SUBROUTINES

=head2 run ()

@run run/run „Executes Perl code in the context of the current project”

	my $aion_run_runScript = Aion::Run::RunScript->new;
	$aion_run_runScript->run  # -> .3

=head1 INSTALL

For install this module in your system run next LL<https://metacpan.org/pod/App::cpm>:

	sudo cpm install -gvv Aion::Run::RunScript

=head1 AUTHOR

Yaroslav O. Kosmina LL<mailto:darviarush@mail.ru>

=head1 LICENSE

⚖ B<GPLv3>

=head1 COPYRIGHT

The Aion::Run::RunScript module is copyright © 2023 Yaroslav O. Kosmina. Rusland. All rights reserved.

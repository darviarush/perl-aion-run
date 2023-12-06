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

Aion::Run::RunScript - evaluate perl-code and print result to stdout

=head1 SYNOPSIS

	use Aion::Format qw/trappout/;
	use Aion::Run::RunScript;
	
	trappout { Aion::Run::RunScript->new(code => "1+2")->run }  # => 3

=head1 DESCRIPTION

This class implements script C<< $ run E<lt>codeE<gt> >> for evaluation.

=head1 FEATURES

=head2 code

Code for evaluation.

=head1 SUBROUTINES

=head2 run ()

Executes Perl code in the context of the current project.

=head1 AUTHOR

Yaroslav O. Kosmina L<mailto:darviarush@mail.ru>

=head1 LICENSE

⚖ B<GPLv3>

=head1 COPYRIGHT

The Aion::Run::RunScript module is copyright © 2023 Yaroslav O. Kosmina. Rusland. All rights reserved.

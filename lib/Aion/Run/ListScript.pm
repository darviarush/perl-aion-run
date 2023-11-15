package Aion::Run::ListScript;
# Печатает список команд Aion::Run на stdout
use common::sense;
use List::Util qw/max/;
use Aion::Format qw/printcolor/;
use Aion;

with qw/Aion::Run/;

# Маска для фильтра по командам
# Mask for filter about commands
has mask => (is => "ro", isa => Maybe[Str], arg => 1);

#@run run/runs „List of scripts”
sub list {
	my ($self) = @_;

	my @runs = sort {
		$a->{rubric} eq $b->{rubric}? ($a->{name} cmp $b->{name}): $a->{rubric} cmp $b->{rubric}
	} $self->runs;

	my $len = max map length $_->{name}, @runs;

	my $rubric;
	for(@runs) {
		printcolor "#yellow%s#r\n", $rubric = $_->{rubric} if $rubric ne $_->{rubric};

		printcolor "  #green%-${len}s #{bold black}%s#r\n", $_->{name}, $_->{remark};
	}
}

my $PATH_SEP = $^O =~ /MSWin|Windows_NT/i ? ";" : ":";

# Возвращает список скриптов
sub runs {
	my ($self) = @_;
	my @runs;
	my $f;
	my $mask = $self->mask;

	for("script", split $PATH_SEP, $ENV{PATH}) {
		push @runs, map {
			my %x;
			my $ok = -x && -r && -f && /()$mask/
			&& open($f, "<:raw", $_)
			&& <$f> =~ m{^#!/usr/bin/env perl}
			&& <$f> =~ /^# rubric: (.*)/ && ($x{rubric} = $1)
			&& <$f> =~ /^# remark: (.*)/ && ($x{remark} = $1)
			&& <$f> =~ /^#   name: (.*)/ && (  $x{name} = $1)
			&& <$f> =~ /^use ([\w:]+);/  && (   $x{pkg} = $1)
			&& <$f> =~ /^(?:[\w:]+)->new_from_args\(\\\@ARGV\)->(\w+);/
				&& ($x{method} = $1);

			close $f;

			$ok? \%x: ()
		} <$_/*> if -d;
	};
	
	@runs
}

1;

__END__

=encoding utf-8

=head1 NAME

Aion::Run::ListScript - 

=head1 SYNOPSIS

	use Aion::Run::ListScript;
	
	my $aion_run_listScript = Aion::Run::ListScript->new;

=head1 DESCRIPTION

.

=head1 FEATURES

=head2 mask

.

	my $aion_run_listScript = Aion::Run::ListScript->new;
	
	$aion_run_listScript->mask	# -> .5

=head1 SUBROUTINES

=head2 list ()

@run run/runs „List of scripts”

	my $aion_run_listScript = Aion::Run::ListScript->new;
	$aion_run_listScript->list  # -> .3

=head2 runs ()

Возвращает список скриптов

	my $aion_run_listScript = Aion::Run::ListScript->new;
	$aion_run_listScript->runs  # -> .3

=head1 INSTALL

For install this module in your system run next LL<https://metacpan.org/pod/App::cpm>:

	sudo cpm install -gvv Aion::Run::ListScript

=head1 AUTHOR

Yaroslav O. Kosmina LL<mailto:darviarush@mail.ru>

=head1 LICENSE

⚖ B<GPLv3>

=head1 COPYRIGHT

The Aion::Run::ListScript module is copyright © 2023 Yaroslav O. Kosmina. Rusland. All rights reserved.

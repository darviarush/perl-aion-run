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

my $PATH_SEP = $^O =~ /MSWin|Windows_NT/i ? ";" : ":";

#@run run/runs „List of scripts”
sub list {
	my ($self) = @_;

    my $mask = $self->mask;
	my @runs;
	my $f;

	for("script", split $PATH_SEP, $ENV{PATH}) {
		push @runs, map {
			my %x;
			my $ok = -x && -r && -f && /()$mask/
			&& open($f, "<:raw", $_)
			&& <$f> =~ m{^#!/usr/bin/env perl}
			&& <$f> =~ /^# rubric: (.*)/ && ($x{rubric} = $1)
			&& <$f> =~ /^# remark: (.*)/ && ($x{remark} = $1)
			&& <$f> =~ /^#   name: (.*)/ && (  $x{name} = $1);

			close $f;

			$ok? \%x: ()
		} <$_/*> if -d;
	};

	@runs = sort {
		$a->{rubric} eq $b->{rubric}? ($a->{name} cmp $b->{name}): $a->{rubric} cmp $b->{rubric}
	} @runs;

	my $len = max map length $_->{name}, @runs;

	my $rubric;
	for(@runs) {
		printcolor "#yellow%s#r\n", $rubric = $_->{rubric} if $rubric ne $_->{rubric};

		printcolor "  #green%-${len}s #{bold black}%s#r\n", $_->{name}, $_->{remark};
	}
}

1;
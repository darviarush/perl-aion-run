use common::sense; use open qw/:std :utf8/; use Test::More 0.98; sub _mkpath_ { my ($p) = @_; length($`) && !-e $`? mkdir($`, 0755) || die "mkdir $`: $!": () while $p =~ m!/!g; $p } BEGIN { use Scalar::Util qw//; use Carp qw//; $SIG{__DIE__} = sub { my ($s) = @_; if(ref $s) { $s->{STACKTRACE} = Carp::longmess "?" if "HASH" eq Scalar::Util::reftype $s; die $s } else {die Carp::longmess defined($s)? $s: "undef" }}; my $t = `pwd`; chop $t; $t .= '/' . __FILE__; my $s = '/tmp/.liveman/perl-aion-run!aion!run!list-script/'; `rm -fr '$s'` if -e $s; chdir _mkpath_($s) or die "chdir $s: $!"; open my $__f__, "<:utf8", $t or die "Read $t: $!"; read $__f__, $s, -s $__f__; close $__f__; while($s =~ /^#\@> (.*)\n((#>> .*\n)*)#\@< EOF\n/gm) { my ($file, $code) = ($1, $2); $code =~ s/^#>> //mg; open my $__f__, ">:utf8", _mkpath_($file) or die "Write $file: $!"; print $__f__ $code; close $__f__; } } # # NAME
# 
# Aion::Run::ListScript - list of scripts maked annotation `#@run`
# 
# # SYNOPSIS
# 
subtest 'SYNOPSIS' => sub { 
use Aion::Run::ListScript;


Aion::Run::ListScript->new->list

# 
# # DESCRIPTION
# 
# .
# 
# # FEATURES
# 
# ## mask
# 
# .
# 
# # SUBROUTINES
# 
# ## list ()
# 
# List of scripts printed to stdout.
# 
done_testing; }; subtest 'list ()' => sub { 
my $aion_run_listScript = Aion::Run::ListScript->new;
::is scalar do {$aion_run_listScript->list}, scalar do{.3}, '$aion_run_listScript->list  # -> .3';

# 
# ## runs ()
# 
# Returns a list of scripts.
# 
done_testing; }; subtest 'runs ()' => sub { 
::is_deeply scalar do {Aion::Run::ListScript->new->runs}, scalar do {["", ""]}, 'Aion::Run::ListScript->new->runs  # --> ["", ""]';

# 
# # AUTHOR
# 
# Yaroslav O. Kosmina <darviarush@mail.ru>
# 
# # LICENSE
# 
# ⚖ **GPLv3**
# 
# # COPYRIGHT
# 
# The Aion::Run::ListScript module is copyright © 2023 Yaroslav O. Kosmina. Rusland. All rights reserved.

	done_testing;
};

done_testing;

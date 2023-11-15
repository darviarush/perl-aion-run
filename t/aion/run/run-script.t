use common::sense; use open qw/:std :utf8/; use Test::More 0.98; sub _mkpath_ { my ($p) = @_; length($`) && !-e $`? mkdir($`, 0755) || die "mkdir $`: $!": () while $p =~ m!/!g; $p } BEGIN { use Scalar::Util qw//; use Carp qw//; $SIG{__DIE__} = sub { my ($s) = @_; if(ref $s) { $s->{STACKTRACE} = Carp::longmess "?" if "HASH" eq Scalar::Util::reftype $s; die $s } else {die Carp::longmess defined($s)? $s: "undef" }}; my $t = `pwd`; chop $t; $t .= '/' . __FILE__; my $s = '/tmp/.liveman/perl-aion-run!aion!run!run-script/'; `rm -fr '$s'` if -e $s; chdir _mkpath_($s) or die "chdir $s: $!"; open my $__f__, "<:utf8", $t or die "Read $t: $!"; read $__f__, $s, -s $__f__; close $__f__; while($s =~ /^#\@> (.*)\n((#>> .*\n)*)#\@< EOF\n/gm) { my ($file, $code) = ($1, $2); $code =~ s/^#>> //mg; open my $__f__, ">:utf8", _mkpath_($file) or die "Write $file: $!"; print $__f__ $code; close $__f__; } } # # NAME
# 
# Aion::Run::RunScript - 
# 
# # SYNOPSIS
# 
subtest 'SYNOPSIS' => sub { 
use Aion::Run::RunScript;

my $aion_run_runScript = Aion::Run::RunScript->new;

# 
# # DESCRIPTION
# 
# .
# 
# # FEATURES
# 
# ## code
# 
# .
# 
done_testing; }; subtest 'code' => sub { 
my $aion_run_runScript = Aion::Run::RunScript->new;

::is scalar do {$aion_run_runScript->code}, scalar do{.5}, '$aion_run_runScript->code	# -> .5';

# 
# # SUBROUTINES
# 
# ## run ()
# 
# @run run/run „Executes Perl code in the context of the current project”
# 
done_testing; }; subtest 'run ()' => sub { 
my $aion_run_runScript = Aion::Run::RunScript->new;
::is scalar do {$aion_run_runScript->run}, scalar do{.3}, '$aion_run_runScript->run  # -> .3';

# 
# # INSTALL
# 
# For install this module in your system run next [command](https://metacpan.org/pod/App::cpm):
# 

# sudo cpm install -gvv Aion::Run::RunScript

# 
# # AUTHOR
# 
# Yaroslav O. Kosmina [darviarush@mail.ru](mailto:darviarush@mail.ru)
# 
# # LICENSE
# 
# ⚖ **GPLv3**
# 
# # COPYRIGHT
# 
# The Aion::Run::RunScript module is copyright © 2023 Yaroslav O. Kosmina. Rusland. All rights reserved.

	done_testing;
};

done_testing;

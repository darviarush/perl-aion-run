use common::sense; use open qw/:std :utf8/; use Test::More 0.98; sub _mkpath_ { my ($p) = @_; length($`) && !-e $`? mkdir($`, 0755) || die "mkdir $`: $!": () while $p =~ m!/!g; $p } BEGIN { use Scalar::Util qw//; use Carp qw//; $SIG{__DIE__} = sub { my ($s) = @_; if(ref $s) { $s->{STACKTRACE} = Carp::longmess "?" if "HASH" eq Scalar::Util::reftype $s; die $s } else {die Carp::longmess defined($s)? $s: "undef" }}; my $t = `pwd`; chop $t; $t .= '/' . __FILE__; my $s = '/tmp/.liveman/perl-aion-run!aion!run!scan-script/'; `rm -fr '$s'` if -e $s; chdir _mkpath_($s) or die "chdir $s: $!"; open my $__f__, "<:utf8", $t or die "Read $t: $!"; read $__f__, $s, -s $__f__; close $__f__; while($s =~ /^#\@> (.*)\n((#>> .*\n)*)#\@< EOF\n/gm) { my ($file, $code) = ($1, $2); $code =~ s/^#>> //mg; open my $__f__, ">:utf8", _mkpath_($file) or die "Write $file: $!"; print $__f__ $code; close $__f__; } } # # NAME
# 
# Aion::Run::ScanScript - script "ann" for appling annotations in perl-modules in the current project
# 
# # SYNOPSIS
# 
# File lib/Aion/FirstExample/Annotation.pm:
#@> lib/Aion/FirstExample/Annotation.pm
#>> package Aion::FirstExample::Annotation;
#>> 
#>> our @ex;
#>> 
#>> sub apply {
#>>     my ($pkg, $sub, $annotation) = @_;
#>>     push @ex, [$pkg, $sub, $annotation];
#>> }
#>> 
#>> 1;
#@< EOF
# 
# File lib/Ex.pm:
#@> lib/Ex.pm
#>> package Ex;
#>> 
#>> #@first-example hi! „First example”
#>> sub mysub {}
#>> 
#>> 1;
#@< EOF
# 
subtest 'SYNOPSIS' => sub { 
use Aion::Run::ScanScript;
Aion::Run::ScanScript->new(show=>0)->apply_annotations;

::is_deeply scalar do {\@Aion::FirstExample::Annotation::ex}, scalar do {["Ex", "mysub", "hi! „First example”"]}, '\@Aion::FirstExample::Annotation::ex # --> ["Ex", "mysub", "hi! „First example”"]';

# 
# # DESCRIPTION
# 
# Annotation is the line as `#@name paramline` before subroutine. Script `ann` (same as `Aion::Run::ScanScript->new(show=>XXX)->apply_annotations`) and load perl-module as `Aion::{name}::Annotation` and call `apply`-subroutine from it.
# 
# # FEATURES
# 
# ## show
# 
# Showing scan-process to stdout.
# 
# # SUBROUTINES
# 
# ## apply_annotations ()
# 
# Scans the current project and applies annotations.
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
# The Aion::Run::ScanScript module is copyright © 2023 Yaroslav O. Kosmina. Rusland. All rights reserved.

	done_testing;
};

done_testing;

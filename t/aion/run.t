use common::sense; use open qw/:std :utf8/; use Test::More 0.98; sub _mkpath_ { my ($p) = @_; length($`) && !-e $`? mkdir($`, 0755) || die "mkdir $`: $!": () while $p =~ m!/!g; $p } BEGIN { use Scalar::Util qw//; use Carp qw//; $SIG{__DIE__} = sub { my ($s) = @_; if(ref $s) { $s->{STACKTRACE} = Carp::longmess "?" if "HASH" eq Scalar::Util::reftype $s; die $s } else {die Carp::longmess defined($s)? $s: "undef" }}; my $t = `pwd`; chop $t; $t .= '/' . __FILE__; my $s = '/tmp/.liveman/perl-aion-run!aion!run/'; `rm -fr '$s'` if -e $s; chdir _mkpath_($s) or die "chdir $s: $!"; open my $__f__, "<:utf8", $t or die "Read $t: $!"; read $__f__, $s, -s $__f__; close $__f__; while($s =~ /^#\@> (.*)\n((#>> .*\n)*)#\@< EOF\n/gm) { my ($file, $code) = ($1, $2); $code =~ s/^#>> //mg; open my $__f__, ">:utf8", _mkpath_($file) or die "Write $file: $!"; print $__f__ $code; close $__f__; } } # # NAME
# 
# Aion::Run - role for make console commands
# 
# # VERSION
# 
# 0.0.0-prealpha
# 
# # SYNOPSIS
# 
# File lib/Scripts/MyScript.pm:
#@> lib/Scripts/MyScript.pm
#>> package Scripts::MyScript;
#>> use common::sense;
#>> use Aion;
#>> 
#>> use DDP; p @INC;
#>> 
#>> with qw/Aion::Run/;
#>> 
#>> # Operands for calculations
#>> has operands => (is => "ro+", isa => ArrayRef[Int], arg => "-a");
#>> 
#>> # Operator for calculations
#>> has operator => (is => "ro+", isa => Enum[qw!+ - * /!], arg => 1);
#>> 
#>> #@run math/calc „Calculate”
#>> sub calculate_sum {
#>>     my ($self) = @_;
#>>     printf "Result: %g", reduce {
#>>         given($self->operator) {
#>>             $a+$b when /\+/;
#>>             $a-$b when /\-/;
#>>             $a*$b when /\*/;
#>>             $a/$b when /\//;
#>>         }
#>>     } @{$self->operands};
#>> }
#>> 
#>> 1;
#@< EOF
# 
subtest 'SYNOPSIS' => sub { 
use Aion::Run::ScanScript;

# Apply annotations:
Aion::Run::ScanScript->new(show => 0)->apply_annotations;

::is scalar do {-x "script/calc"}, scalar do{1}, '-x "script/calc"  # -> 1';
::is scalar do {-x "$ENV{HOME}/.local/bin/calc"}, scalar do{1}, '-x "$ENV{HOME}/.local/bin/calc"  # -> 1';

::is scalar do {`calc -a 1 -a 2 -a 3 +`}, scalar do{6}, '`calc -a 1 -a 2 -a 3 +`  # -> 6';
::is scalar do {`calc '*' --operands=4 --operands=2`}, scalar do{8}, '`calc \'*\' --operands=4 --operands=2`  # -> 8';

unlink "$ENV{HOME}/.local/bin/calc";

# 
# # DESCRIPTION
# 
# Role `Aion::Run` implements aspect `arg` for make feature as command-line param.
# 
# * `arg => number` — make ordered parameter.
# * `arg => "-X"` — make keyed parameter.
# 
# # METHODS
# 
# ## new_from_args ($pkg, $args)
# 
# Constructor. It creates a script-object with command-line parameters.
# 
done_testing; }; subtest 'new_from_args ($pkg, $args)' => sub { 
use lib "lib";
use Scripts::MyScript;
::is_deeply scalar do {Scripts::MyScript->new_from_args([qw/-a 1 -a 2 -a 3 +/])->operands}, scalar do {[1,2,3]}, 'Scripts::MyScript->new_from_args([qw/-a 1 -a 2 -a 3 +/])->operands  # --> [1,2,3]';

# 
# # AUTHOR
# 
# Yaroslav O. Kosmina <dart@cpan.org>
# 
# # LICENSE
# 
# ⚖ **GPLv3**
# 
# # COPYRIGHT
# 
# The Aion::Run module is copyright (с) 2023 Yaroslav O. Kosmina. Rusland. All rights reserved.

	done_testing;
};

done_testing;

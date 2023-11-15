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
subtest 'SYNOPSIS' => sub { 
use Aion::Run;

my $aion_run = Aion::Run->new();

# 
# # DESCRIPTION
# 
# 
# 
# # METHODS
# 
# ## 
# 
# .
# 
done_testing; }; subtest '' => sub { 
my $aion_run = Aion::Run->new();

# 
# ## new_from_args ($pkg, $args)
# 
# Создаёт объект с параметрами запроса
# 
done_testing; }; subtest 'new_from_args ($pkg, $args)' => sub { 
my $aion_run = Aion::Run->new;
::is scalar do {$aion_run->new_from_args($pkg, $args)}, scalar do{.3}, '$aion_run->new_from_args($pkg, $args)  # -> .3';

# 
# # INSTALL
# 
# Add to **cpanfile** in your project:
# 

# requires 'Aion::Run',
#     git => 'https://github.com/darviarush/perl-aion-run.git',
#     ref => 'master',
# ;

# 
# And run command:
# 

# $ sudo cpm install -gvv

# 
# # AUTHOR
# 
# Yaroslav O. Kosmina <dart@cpan.org>
# 
# # LICENSE
# 
# ⚖ **GPLv3**

	done_testing;
};

done_testing;

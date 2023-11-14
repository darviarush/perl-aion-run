package Aion::Run::Annotation;
use common::sense;

use Aion::Fs qw/mkpath cat lay/;

# Создаёт по аннотации скрипт
sub apply {
    my ($pkg, $sub, $annotation) = @_;

    return "Annotation error. Use #\@run <rubric>/<name> <remark>" if $annotation !~ /^(\w+)\/(\w+)[ \t]+(.+)/am;

    my ($rubric, $name, $remark) = ($1, $2, $3);

    my $path = "script/$name";

    my $script = << "END";
#!/usr/bin/env perl
# rubric: $rubric
# remark: $remark
#   name: $name
use $pkg;
$pkg->new_from_args(\\\@ARGV)->$sub;
END
    if(!-e $path or cat $path ne $script) {
        lay mkpath $path, $script;
        chmod 0755, $path or die "chmod +x $path: $!";
    }
}

1;
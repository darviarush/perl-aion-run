package Aion::Run::Annotation;
use common::sense;

use Aion::Fs qw/mkpath cat lay/;
use Aion::Format qw/to_str/;
use Cwd qw/cwd/;

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

    my $mia = sub {
        if(!-e $path or cat $path ne $script) {
            lay mkpath $path, $script;
            chmod 0755, $path or die "chmod +x $path: $!";
        }
    };
    $mia->();

    my $lib = to_str(cwd() . "/lib");
    $script =~ s!^use!use lib $lib;\n$&!m;
    $path = "$ENV{HOME}/.local/bin/$name";

    $mia->();
}

1;

__END__

=encoding utf-8

=head1 NAME

Aion::Run::Annotation - appling annotation C<#@run> for maked scripts

=head1 SYNOPSIS

	use Aion::Run::Annotation;
	
	Aion::Run::Annotation->can("apply")->("", "", "");

=head1 DESCRIPTION

.

=head1 SUBROUTINES

=head2 apply ($pkg, $sub, $annotation)

Creates a script based on an annotation.

=head1 AUTHOR

Yaroslav O. Kosmina L<mailto:darviarush@mail.ru>

=head1 LICENSE

⚖ B<GPLv3>

=head1 COPYRIGHT

The Aion::Run::Annotation module is copyright © 2023 Yaroslav O. Kosmina. Rusland. All rights reserved.

# NAME

Aion::Run - role for make console commands

# VERSION

0.0.0-prealpha

# SYNOPSIS

File lib/Scripts/MyScript.pm:
```perl
package Scripts::MyScript;
use common::sense;
use Aion;

with qw/Aion::Run/;

has operands => (is => "ro+", isa => ArrayRef[Int], arg => "-a");
has operator => (is => "ro+", isa => Enum[qw!+ - * /!], arg => "-o");

#@run math/calc „Calculate”
sub calculate_sum {
    my ($self) = @_;
    printf "Result: %g", reduce {
        given($self->operator) {
            $a+$b when /\+/;
            $a-$b when /\-/;
            $a*$b when /\*/;
            $a/$b when /\//;
        }
    } @{$self->operands};
}

1;
```

```
`perl -`
```

# DESCRIPTION



# METHODS

## 

.

```perl
my $aion_run = Aion::Run->new();
```

## new_from_args ($pkg, $args)

Создаёт объект с параметрами запроса

```perl
my $aion_run = Aion::Run->new;
$aion_run->new_from_args($pkg, $args)  # -> .3
```

# INSTALL

Add to **cpanfile** in your project:

```cpanfile
requires 'Aion::Run',
    git => 'https://github.com/darviarush/perl-aion-run.git',
    ref => 'master',
;
```

And run command:

```sh
$ sudo cpm install -gvv
```

# AUTHOR

Yaroslav O. Kosmina <dart@cpan.org>

# LICENSE

⚖ **GPLv3**

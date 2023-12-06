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

use DDP; p @INC;

with qw/Aion::Run/;

# Operands for calculations
has operands => (is => "ro+", isa => ArrayRef[Int], arg => "-a");

# Operator for calculations
has operator => (is => "ro+", isa => Enum[qw!+ - * /!], arg => 1);

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

```perl
use Aion::Run::ScanScript;

# Apply annotations:
Aion::Run::ScanScript->new(show => 0)->apply_annotations;

-x "script/calc"  # -> 1
-x "$ENV{HOME}/.local/bin/calc"  # -> 1

`calc -a 1 -a 2 -a 3 +`  # -> 6
`calc '*' --operands=4 --operands=2`  # -> 8

unlink "$ENV{HOME}/.local/bin/calc";
```

# DESCRIPTION

Role `Aion::Run` implements aspect `arg` for make feature as command-line param.

* `arg => number` — make ordered parameter.
* `arg => "-X"` — make keyed parameter.

# METHODS

## new_from_args ($pkg, $args)

Constructor. It creates a script-object with command-line parameters.

```perl
use lib "lib";
use Scripts::MyScript;
Scripts::MyScript->new_from_args([qw/-a 1 -a 2 -a 3 +/])->operands  # --> [1,2,3]
```

# AUTHOR

Yaroslav O. Kosmina <dart@cpan.org>

# LICENSE

⚖ **GPLv3**

# COPYRIGHT

The Aion::Run module is copyright (с) 2023 Yaroslav O. Kosmina. Rusland. All rights reserved.

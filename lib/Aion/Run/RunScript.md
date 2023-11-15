# NAME

Aion::Run::RunScript - evaluate perl-code and print result to stdout

# SYNOPSIS

```perl
use Aion::Format qw/trappout/;
use Aion::Run::RunScript;

trappout { Aion::Run::RunScript->new(code => "1+2")->run }  # => 3
```

# DESCRIPTION

This class implements script `$ run <code>` for evaluation.

# FEATURES

## code

Code for evaluation.

# SUBROUTINES

## run ()

Executes Perl code in the context of the current project.

# AUTHOR

Yaroslav O. Kosmina <darviarush@mail.ru>

# LICENSE

⚖ **GPLv3**

# COPYRIGHT

The Aion::Run::RunScript module is copyright © 2023 Yaroslav O. Kosmina. Rusland. All rights reserved.

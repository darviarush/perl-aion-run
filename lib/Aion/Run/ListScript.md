# NAME

Aion::Run::ListScript - list of scripts maked annotation `#@run`

# SYNOPSIS

```perl
use Aion::Run::ListScript;


Aion::Run::ListScript->new->list
```

# DESCRIPTION

.

# FEATURES

## mask

.

# SUBROUTINES

## list ()

List of scripts printed to stdout.

```perl
my $aion_run_listScript = Aion::Run::ListScript->new;
$aion_run_listScript->list  # -> .3
```

## runs ()

Returns a list of scripts.

```perl
Aion::Run::ListScript->new->runs  # --> ["", ""]
```

# AUTHOR

Yaroslav O. Kosmina <darviarush@mail.ru>

# LICENSE

⚖ **GPLv3**

# COPYRIGHT

The Aion::Run::ListScript module is copyright © 2023 Yaroslav O. Kosmina. Rusland. All rights reserved.

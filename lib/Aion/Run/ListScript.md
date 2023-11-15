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

```perl
my $aion_run_listScript = Aion::Run::ListScript->new;

$aion_run_listScript->mask	# -> .5
```

# SUBROUTINES

## list ()

@run run/runs „List of scripts”

```perl
my $aion_run_listScript = Aion::Run::ListScript->new;
$aion_run_listScript->list  # -> .3
```

## runs ()

Возвращает список скриптов

```perl
my $aion_run_listScript = Aion::Run::ListScript->new;
$aion_run_listScript->runs  # -> .3
```

# INSTALL

For install this module in your system run next [command](https://metacpan.org/pod/App::cpm):

```sh
sudo cpm install -gvv Aion::Run::ListScript
```

# AUTHOR

Yaroslav O. Kosmina [darviarush@mail.ru](mailto:darviarush@mail.ru)

# LICENSE

⚖ **GPLv3**

# COPYRIGHT

The Aion::Run::ListScript module is copyright © 2023 Yaroslav O. Kosmina. Rusland. All rights reserved.

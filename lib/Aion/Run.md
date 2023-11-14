# NAME

Aion::Run - role for make console commands

# VERSION

0.0.0-prealpha

# SYNOPSIS

```perl
use Aion::Run;

my $aion_run = Aion::Run->new();
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

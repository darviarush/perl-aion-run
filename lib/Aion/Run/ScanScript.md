# NAME

Aion::Run::ScanScript - script "ann" for appling annotations in perl-modules in the current project

# SYNOPSIS

File lib/Aion/FirstExample/Annotation.pm:
```perl
package Aion::FirstExample::Annotation;

our @ex;

sub apply {
    my ($pkg, $sub, $annotation) = @_;
    push @ex, [$pkg, $sub, $annotation];
}

1;
```

File lib/Ex.pm:
```perl
package Ex;

#@first-example hi! „First example”
sub mysub {}

1;
```

```perl
use Aion::Run::ScanScript;
Aion::Run::ScanScript->new(show=>0)->apply_annotations;

\@Aion::FirstExample::Annotation::ex # --> ["Ex", "mysub", "hi! „First example”"]
```

# DESCRIPTION

Annotation is the line as `#@name paramline` before subroutine. Script `ann` (same as `Aion::Run::ScanScript->new(show=>XXX)->apply_annotations`) and load perl-module as `Aion::{name}::Annotation` and call `apply`-subroutine from it.

# FEATURES

## show

Showing scan-process to stdout.

# SUBROUTINES

## apply_annotations ()

Scans the current project and applies annotations.

# AUTHOR

Yaroslav O. Kosmina <darviarush@mail.ru>

# LICENSE

⚖ **GPLv3**

# COPYRIGHT

The Aion::Run::ScanScript module is copyright © 2023 Yaroslav O. Kosmina. Rusland. All rights reserved.

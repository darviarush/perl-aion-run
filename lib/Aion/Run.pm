package Aion::Run;
use common::sense;

our $VERSION = "0.0.0-prealpha";

use Aion -role;

# Позволяет проставлять однобуквенные ключи (-x) в соответствие фичам
aspect arg => sub {
	my ($pkg, $name, $arg, $construct, $feature) = @_;
	die "has $name: arg=`$arg` - and only `-A` parameters are allowed!" unless $arg =~ /^(?:-\w|\d+)\z/a;
	$feature->{arg} = $arg;
	$Aion::META{$pkg}{arg}{$arg} = $feature;
};

# Создаёт объект с параметрами запроса
sub new_from_args {
	my ($pkg, $args) = @_;

	my $meta = $Aion::META{$pkg};
	my $FEATURE = $meta->{feature};
	my $ARG = $meta->{arg};

	my $get_feature = sub {
		my ($key) = @_;
		die "Not feature ${pkg}->$key" unless my $feature = $FEATURE->{$key};
		$feature
	};

	my %param;

	my $set_feature = sub {
		my ($key, $val) = @_;
		my $feature = $get_feature->($key);
		given($feature->{isa}{name}) {
			push @{$param{$key}}, $val when "ArrayRef";
			default {
				die "Key $key / $feature->{arg} already specified on the command line!" if exists $param{$key};
				$param{$key} = $val;
			}
		}
	};

	my $count = 0;

	for(my $i=0; $i<@$args; $i++) {
		local $_ = $args->[$i];
		if(/^--([\w-]+)(?:=(.*))?\z/a) {
			$set_feature->($1, $2);
		} elsif(/^-(\w+)\z/a) {
			for(split //, $1) {
				my $feature = $ARG->{"-$_"};
				my $key = $feature->{name};
				my $feature = $get_feature->($key);
				if($feature->{isa}{name} eq "Bool") {
					$set_feature->($key, !!$feature->{default});
				} else {
					$set_feature->($key, $args->[++$i]);
				}
			}
		} else {
			my $feature = $ARG->{++$count};
			my $key = $feature->{name};
			$set_feature->($key, $_);
		}
	}

	$pkg->new(%param)
}

1;

__END__

=encoding utf-8

=head1 NAME

Aion::Run - role for make console commands

=head1 VERSION

0.0.0-prealpha

=head1 SYNOPSIS

	use Aion::Run;
	
	my $aion_run = Aion::Run->new();

=head1 DESCRIPTION

=head1 METHODS

=head2  

.

	my $aion_run = Aion::Run->new();

=head2 new_from_args ($pkg, $args)

Создаёт объект с параметрами запроса

	my $aion_run = Aion::Run->new;
	$aion_run->new_from_args($pkg, $args)  # -> .3

=head1 INSTALL

Add to B<cpanfile> in your project:

	requires 'Aion::Run',
	    git => 'https://github.com/darviarush/perl-aion-run.git',
	    ref => 'master',
	;

And run command:

	$ sudo cpm install -gvv

=head1 AUTHOR

Yaroslav O. Kosmina L<mailto:dart@cpan.org>

=head1 LICENSE

⚖ B<GPLv3>

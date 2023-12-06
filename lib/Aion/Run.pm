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

File lib/Scripts/MyScript.pm:

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



	use Aion::Run::ScanScript;
	
	# Apply annotations:
	Aion::Run::ScanScript->new(show => 0)->apply_annotations;
	
	-x "script/calc"  # -> 1
	-x "$ENV{HOME}/.local/bin/calc"  # -> 1
	
	`calc -a 1 -a 2 -a 3 +`  # -> 6
	`calc '*' --operands=4 --operands=2`  # -> 8
	
	unlink "$ENV{HOME}/.local/bin/calc";

=head1 DESCRIPTION

Role C<Aion::Run> implements aspect C<arg> for make feature as command-line param.

=over

=item * C<< arg =E<gt> number >> — make ordered parameter.

=item * C<< arg =E<gt> "-X" >> — make keyed parameter.

=back

=head1 METHODS

=head2 new_from_args ($pkg, $args)

Constructor. It creates a script-object with command-line parameters.

	use lib "lib";
	use Scripts::MyScript;
	Scripts::MyScript->new_from_args([qw/-a 1 -a 2 -a 3 +/])->operands  # --> [1,2,3]

=head1 AUTHOR

Yaroslav O. Kosmina L<mailto:dart@cpan.org>

=head1 LICENSE

⚖ B<GPLv3>

=head1 COPYRIGHT

The Aion::Run module is copyright (с) 2023 Yaroslav O. Kosmina. Rusland. All rights reserved.

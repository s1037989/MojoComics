package Comics::Date;
use Mojo::Base 'Comics::Core';

use overload '""' => sub { shift->_collection }, fallback=>1;

use Date::Simple::D8;

has dates  => sub { [] };
has format => '%A, %B %d, %Y';
has start  => sub { Date::Simple::D8->new };
has end    => sub { Date::Simple::D8->new };
has first  => sub { Date::Simple::D8->new(File::Basename::basename ((sort glob($_[0]->repo($_[0]->base_url, '*')))[0])) || $_[0]->start };
has today  => sub { Date::Simple::D8->new };

has _day_length => 1;
has _collection => sub { Comics::Date::Collection->new };

sub new { shift->SUPER::new(@_)->recollect }

sub recollect {
  my $self = shift;
  ref $self->dates eq 'ARRAY' or return undef;
  $self->dates->[1] ||= $self->dates->[0];
  my @dates = sort { $a <=> $b } map { $_ ? Date::Simple::D8->new($_) : Date::Simple::D8->new } @{$self->dates}[0,1];
  $_->default_format($self->format) foreach @dates;
  $self->start($dates[0])->end($dates[1]);
  my $start = $self->start;
  for (1..$self->length) {
      push @{$self->_collection}, $start;
      $start += $self->_day_length;
  }
  $self;
}

sub length { (int ($_[0]->end - $_[0]->start) / $_[0]->_day_length)  +1 }

sub collection { shift->_collection }
sub c { shift->_collection }

package Comics::Date::Collection;
use Mojo::Base 'Mojo::Collection';

sub random { shift->shuffle->first }

1;

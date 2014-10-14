package Comics::Strips;
use Mojo::Base -base;

use overload '""' => sub { shift->_collection }, fallback=>1;

use Comics::Date;
use Comics::Strip;

has 'comic';
has date => sub { Comics::Date->new(dates => shift->comic->dates) };

has _collection => sub { Comics::Strips::Collection->new };

sub new { shift->SUPER::new(@_)->recollect }

sub recollect {
  my $self = shift;
  $self->_collection(Comics::Strips::Collection->new);
  foreach my $date ( $self->date->collection->each ) {
    push @{$self->_collection}, Comics::Strip->new(comic => $self->comic, date => $date) unless $self->_collection->grep(sub{$_ eq $date});
  }
  $self;
}

sub collection { shift->_collection }
sub c { shift->_collection }

sub strip { shift->collection->grepdate(shift)->first }

package Comics::Strips::Collection;
use Mojo::Base 'Mojo::Collection';

sub grepdate {
  my ($self, $grep) = @_;
  
  ref $grep eq 'Regexp' ? $self->grep(sub { $_->date =~ $grep }) : $self->grep(sub { $_->date eq $grep });
} 

1;

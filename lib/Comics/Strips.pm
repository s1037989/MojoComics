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

sub strip {
  my ($self, $date) = @_;
  $self->collection->grepdate($date)->first || Comics::Strip->new(comic => $self->comic, date => $date);
}

sub previous {
  my ($self, $date) = @_;
  Comics::Date->new(dates => [$self->date->first, $date-1])->collection->reverse->map(sub {
    my $strip = Comics::Strip->new(comic => $self->comic, date => $_);
    $strip->exists ? $strip : undef;
  })->compact->first || $self->strip($date);
}

sub run {
  my ($self, $date) = @_;
  if ( @{$self->comic->days} ) {
    return 0 unless grep { ($self->collection->grepdate($date || $self->date->start)->map(sub{$_->date->format('%a')})->first || '') eq $_ } @{$self->comic->days};
  }
  return 1;
}

sub exist { shift->collection->grep(sub{$_->exists})->size }

package Comics::Strips::Collection;
use Mojo::Base 'Mojo::Collection';

sub grepdate {
  my ($self, $grep) = @_;
  
  ref $grep eq 'Regexp' ? $self->grep(sub { $_->date =~ $grep }) : $self->grep(sub { $_->date eq $grep });
} 

1;

package Comics::Comics;
use Mojo::Base 'Comics::Core';

our $VERSION = '0.01';

use overload '""' => sub { shift->_collection }, fallback=>1;

use Mojo::Util 'decamelize';
use Mojo::Loader;

use List::AllUtils 'uniq';

has 'collection';

has _collection => sub { Comics::Collection->new };

sub new { shift->SUPER::new(@_)->recollect }

sub recollect {
  my $self = shift;
  $self->_collection(Comics::Collection->new);
  my $l = Mojo::Loader->new;
  #foreach ( uniq grep { not exists $self->_loaded->{$_} } grep { $self->name ? $_ eq $self->name : $_ } (map { join '::', $self->namespace, $_ } $self->order), sort @{$l->search($self->namespace)} ) {
  foreach my $module ( sort grep { $self->basepackagename($_) eq lc($self->basepackagename($_)) } @{$l->search($self->collection->namespace)} ) {
    $l->load($module) and next;
    my $comic = $module->new(dates => $self->dates) unless $self->_collection->grep(sub{ref $_ eq $module});
    push @{$self->_collection}, $comic;
  }
  $self;
}

sub collection { shift->_collection }
sub c { shift->collection }

sub comic { $_[0]->collection->grepcomic($_[1] || $_[0]->class)->first }

package Comics::Collection;
use Mojo::Base 'Mojo::Collection';

sub grepcomic {
  my ($self, $grep) = @_;
  
  ref $grep eq 'Regexp' ? $self->grep(sub { $_->class =~ $grep || $_->name =~ $grep }) : $self->grep(sub { lc($_->class) eq lc($grep) || lc($_->name) eq lc($grep) });
}

1;

package App::Comics;
use Mojo::Base 'App';

our $VERSION = '0.01';

use Comics::Library;

has library => sub { Comics::Library->new };

# This method will run once at server start
sub startup {
  my $self = shift;

  $self->plugin('DateSimple' => {FMT => 'D8'});

  # Add app commands
  $self->add_commands;

  # Router
  my $r = $self->routes;

  # One day of all available comics
  $r->get('/:date', [date => qr/\d{8}/], {date => ''})->to('display#daily')->name('daily');
  # One or more days of one specific comic
  $r->get('/:comic/:from/:to', [comic => qw/\w+/, from => qr/\d{8}/, to => qr/\d{8}/], {from => '', to => ''})->to('display#book')->name('book');
}

1;

package App;
use Mojo::Base 'Mojolicious';

sub add_commands {
  my $self = shift;
  unshift @{$self->app->commands->namespaces}, (@_ || join '::', (caller)[0], 'Command');
}

1;

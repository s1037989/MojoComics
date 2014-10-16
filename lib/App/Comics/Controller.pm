package App::Comics::Controller;
use Mojo::Base 'Mojolicious::Controller';

sub d8 {
  my ($self, $param) = @_;
  $self->datesimple->d8($self->param($param))
}

1;

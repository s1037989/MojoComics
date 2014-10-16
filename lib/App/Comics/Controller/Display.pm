package App::Comics::Controller::Display;
use Mojo::Base 'Mojolicious::Controller';

has comics => sub { shift->app->comics };

# This action will render a template
sub daily {
  my $self = shift;

  $self->comics->dates([$self->_d8('date')])->recollect;

  $self->render(msg => 'Daily', comics => $self->comics);
}

# This action will render a template
sub book {
  my $self = shift;

  $self->comics->name($self->param('name'))->dates([$self->_d8('from'), $self->_d8('to')])->recollect;

  $self->render(msg => 'Book', comic => $self->comics->comic);
}

sub _d8 {
  my ($self, $param) = @_;
  $self->datesimple->d8($self->param($param))
}

1;

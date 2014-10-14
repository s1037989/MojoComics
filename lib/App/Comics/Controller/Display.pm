package App::Comics::Controller::Display;
use Mojo::Base 'Mojolicious::Controller';

has comics => sub { shift->app->comics };

# This action will render a template
sub daily {
  my $self = shift;

  $self->comics->dates([$self->param('date')])->recollect;

  $self->render(msg => 'Daily', comics => $self->comics);
}

# This action will render a template
sub book {
  my $self = shift;

  $self->comics->name($self->param('name'))->dates([$self->param('from'), $self->param('to')])->recollect;

  $self->render(msg => 'Book', comic => $self->comics->comic);
}

1;

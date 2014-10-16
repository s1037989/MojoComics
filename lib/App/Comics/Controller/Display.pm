package App::Comics::Controller::Display;
use Mojo::Base 'App::Comics::Controller';

has library => sub { shift->app->library };

# This action will render a template
sub daily {
  my $self = shift;

  $self->library->dates([$self->d8('date')])->recollect;

  $self->render(msg => 'Daily');
}

# This action will render a template
sub book {
  my $self = shift;

  $self->library->comic($self->param('comic'))->dates([$self->d8('from'), $self->d8('to')])->recollect;

  $self->render(msg => 'Book');
}

1;

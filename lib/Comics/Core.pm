package Comics::Core;
use Mojo::Base -base;

use Mojo::Home;
#use Mojo::Storage;

use File::Spec::Functions 'catdir';

has 'dates';
has base_url => '/'; # /comics/
has img_root => 'public';
has class => sub { shift->basepackagename };
has home => sub { Mojo::Home->new->detect(ref shift) };
#has storage => sub { Mojo::Storage->new };

sub repo {
  my $self = shift;
  $self->home->rel_dir(catdir grep {$_} $self->img_root, @_);
}

sub basepackagename {
  my ($self, $class) = @_;
  (reverse split /::/, $class || ref $self)[0];
}

1;

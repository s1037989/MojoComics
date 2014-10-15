package Comics::Comic;
use Mojo::Base 'Comics::Core'; 

use Mojo::UserAgent;
use Mojolicious::Types;

use Date::Simple::D8;

use Comics::Strips;

has name => 'Sample';
has link => 'http://samp.le';
has strips => sub { Comics::Strips->new(comic => shift) };
sub download { warn "Not yet implemented" }

has '_date';
has _ua => sub { Mojo::UserAgent->new };
has _types => sub { Mojolicious::Types->new };

sub _download {
  my ($self, $strip, $dom) = @_;

  $self->_date($strip->date);
  my $tx = $self->_ua->get($self->_ua->get($self->_resolved_link)->res->dom->$dom->first);
  my $ext = $self->_types->detect($tx->res->headers->content_type)->[0];
  ref $tx->res->content->asset->move_to($strip->abs_path($ext));
}

sub _resolved_link {
  my $self = shift;
  Date::Simple::D8->new($self->_date)->format($self->link);
}

1;

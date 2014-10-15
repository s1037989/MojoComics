package Comics::Comic;
use Mojo::Base 'Comics::Core'; 

use Mojo::UserAgent;
use Mojolicious::Types;

use Date::Simple::D8;

use Comics::Strips;

has name => 'Sample';
has filename => sub { shift->basepackagename };
has link => 'http://samp.le';
has strips => sub { Comics::Strips->new(comic => shift) };
sub download { warn "Not yet implemented" }

has _ua => sub { Mojo::UserAgent->new };
has _types => sub { Mojolicious::Types->new };

sub _download {
  my ($self, $strip, $dom) = @_;

  #my $tx = $self->_ua->get($self->_ua->get($self->_resolved_link($strip->date))->res->dom->$dom->first);
  #$strip->ext($self->_types->detect($tx->res->headers->content_type)->[0]);
  #$tx->res->content->asset->move_to($strip->abs_path);
  $strip->exists;
}

sub _resolved_link {
  my ($self, $date) = @_;
  return $self->link unless $date;
  Date::Simple::D8->new($date)->format($self->link);
}

1;

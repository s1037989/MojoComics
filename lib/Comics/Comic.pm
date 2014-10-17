package Comics::Comic;
use Mojo::Base 'Comics::Core'; 

use Mojo::UserAgent;
use Mojolicious::Types;

use Date::Simple::D8;

use Comics::Strips;

has name => sub { warn 'Not implemented' };
has names => sub { [] };
has link => sub { warn 'Not implemented' };
has days => sub { [] };
has dom => sub { shift };
has min_size => 5000;
has strips => sub { Comics::Strips->new(comic => shift) };
has agent => 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/31.0.1650.63 Chrome/31.0.1650.63 Safari/537.36';
has referer => 'http://www.google.com';
has headers => sub { {'User-Agent' => $_[0]->agent, 'Referer' => $_[0]->referer} };

sub datedlink {
  my ($self, $date) = @_;
  my $link = $self->can('datelink') ? $self->datelink : $self->link;
  return $link unless $date;
  $link = Date::Simple::D8->new($date)->format($link);
  $link =~ s/ //g;
  $link;
}

has ua => sub { Mojo::UserAgent->new };
has types => sub { Mojolicious::Types->new };

sub download {
  my ($self, $strip) = @_;
  return 0 unless $self->strips->run($strip->date);
  warn sprintf "Getting %s\n", $self->datedlink($strip->date);
  my $dom = $strip->comic->dom;
  my $tx = $self->ua->get($self->ua->get($self->datedlink($strip->date) => $self->headers)->res->dom->$dom->first => $self->headers);
  $self->save($strip, $tx);
}

sub save {
  my ($self, $strip, $tx) = @_;

  if ( $tx ) {
    $strip->ext($self->types->detect($tx->res->headers->content_type)->[0]);
    my $asset = $tx->res->content->asset;
    return $asset->move_to($strip->abs_path) if $asset->size > $self->min_size && $self->_md5_sum($asset->path) ne $self->_md5_sum($self->strips->previous($strip->date)->abs_path);
  } else {
    warn "No \$tx found\n";
  }
  return undef;
}

sub _md5_sum { shift; return '' unless -e $_[0]; Mojo::Util::md5_sum Mojo::Util::slurp shift }

1;

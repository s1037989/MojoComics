package Comics::Comic;
use Mojo::Base 'Comics::Core'; 

use Mojo::UserAgent;
use Mojolicious::Types;

use Date::Simple::D8;

use Comics::Strips;

has name => 'Sample';
has filename => sub { shift->basepackagename };
has link => 'http://samp.le';
has days => sub { [] };
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
  if ( @{$self->days} ) {
    return 0 unless grep { $_ eq $strip->date->format('%a') } @{$self->days};
  }
  warn sprintf "Getting %s\n", $self->datedlink($strip->date);
  my $tx;# = $self->ua->get($self->ua->get($self->datedlink($strip->date) => $self->headers)->dom->$dom->first => $self->headers);
  $self->save($strip, $tx);
}

sub save {
  my ($self, $strip, $tx) = @_;

  if ( $tx ) {
    $strip->ext($self->types->detect($tx->res->headers->content_type)->[0]);
    $tx->res->content->asset->move_to($strip->abs_path);
  } else {
    warn "No \$tx found\n";
  }

  $strip->exists;
}

1;

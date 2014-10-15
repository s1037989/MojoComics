package Comics::Strip;
use Mojo::Base -base;

use Mojo::Util 'decamelize';

use File::Spec::Functions qw( catdir catfile );

has 'comic';
has 'date';
has 'ext' => 'png';

has '_rel_dir';
has '_abs_dir';

sub new { shift->SUPER::new(@_)->rebase }

sub rebase {
  my $self = shift;
  $self->_rel_dir(catdir $self->comic->base_url, $self->date);
  $self->_abs_dir($self->comic->repo($self->_rel_dir));
  mkdir $self->_abs_dir unless -d $self->_abs_dir;
  if ( !$self->exists ) {
    if ( my $file = (glob(catdir $self->_abs_dir, $self->comic->filename.'*'))[0] ) {
      $file =~ /\.([^\.]+)$/;
      $self->ext($1);
    }
  }
  $self;
}

sub url {
  my $self = shift;
  #$self->date->format($self->link);
}
sub filename {
  my $self = shift;
  join '.', $self->comic->filename, shift || $self->ext;
}
sub rel_url {
  my $self = shift;
  return unless my $filename = $self->filename(shift);
  return $self->exists ? catfile $self->_rel_dir, $filename : '';
}
sub abs_path {
  my $self = shift;
  return unless my $filename = $self->filename(shift);
  return catfile $self->_abs_dir, $filename;
}

sub exists { -e shift->abs_path }
sub size { -s shift->abs_path }
sub mtime { (stat(shift->abs_path))[9] || 0 }

1;

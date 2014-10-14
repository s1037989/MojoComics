package Mojolicious::Command::download;

=head1 NAME

Comics::Command::download - Download command

=head1 DESCRIPTION

L<Comics::Command::download> shows version information for L<Comics>, installed
core and optional modules.

See also L<Mojolicious::Command::download>.

=cut

use Mojo::Base 'Mojolicious::Command';

=head1 METHODS

=head2 run

Run this command.

=cut

has comics => sub { shift->app->comics };

sub run {
  my $self = shift;

  $self->comics->dates(['20141004']);
  say $self->comics->date;
  $self->comics->load or return 1;
  foreach ( $self->comics->get_comics ) {
    say $_->name;
    say $_->link;
    foreach ( $_->get_strips ) {
      say $_->comic->name;
      say $_->comic->link;
      say $_->date->range->start;
      say $_->file->abs_path if $_->file->exists;
      $_->download;
    }
  }
  return 0;
}

=head1 COPYRIGHT

Nordaaker

=head1 AUTHOR

Jan Henning Thorsen - C<jhthorsen@cpan.org>

=cut

1;

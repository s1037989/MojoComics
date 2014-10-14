package App::Comics::Command::version;

=head1 NAME

App::Comics::Command::version - Version command

=head1 DESCRIPTION

L<App::Comics::Command::version> shows version information for L<App::Comics>, installed
core and optional modules.

See also L<Mojolicious::Command::version>.

=cut

use Mojo::Base 'Mojolicious::Command';

has _latest_app_version => sub { App::Comics->VERSION };
has _latest_comics_version => sub { Comics->VERSION };

=head1 METHODS

=head2 run

Run this command.

=cut

sub run {
  my $self           = shift;
  my $app_version    = App::Comics->VERSION;
  my $comics_version = Comics->VERSION;

  $ENV{MOJO_MODE} ||= '';

  print <<EOF;
Comics
  Mode   ($ENV{MOJO_MODE})
  App    ($app_version)
  Comics ($comics_version)

EOF

  if ($self->_latest_app_version and $app_version < $self->_latest_app_version) {
    say "You might want to update your App::Comics to @{[$self->_latest_app_version]}.";
  }
  if ($self->_latest_comics_version and $comics_version < $self->_latest_comics_version) {
    say "You might want to update your Comics to @{[$self->_latest_comics_version]}.";
  }

  return 0;
}

=head1 COPYRIGHT

Stefan Adams

=head1 AUTHOR

Stefan Adams - C<stefan@borgia.com>

=cut

1;

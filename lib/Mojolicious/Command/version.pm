package Mojolicious::Command::version;

=head1 NAME

Comics::Command::version - Version command

=head1 DESCRIPTION

L<Comics::Command::version> shows version information for L<Comics>, installed
core and optional modules.

See also L<Mojolicious::Command::version>.

=cut

use Mojo::Base 'Mojolicious::Command';

has _latest_version => sub { Comics->VERSION };

=head1 METHODS

=head2 run

Run this command.

=cut

sub run {
  my $self         = shift;
  my $code_version = Comics->VERSION;
  my $database_version;

  $ENV{MOJO_MODE} ||= '';

  print <<EOF;
Comics
  Mode     ($ENV{MOJO_MODE})
  Code     ($code_version)
  Database (@{[$database_version || 'Unknown']})

EOF

  #$self->SUPER::run(@_);    # Mojolicious version information

  if ($self->_latest_version and $code_version < $self->_latest_version) {
    say "You might want to update your Comics to @{[$self->_latest_version]}.";
  }

  return 0;
}

=head1 COPYRIGHT

Nordaaker

=head1 AUTHOR

Jan Henning Thorsen - C<jhthorsen@cpan.org>

=cut

1;

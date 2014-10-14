package App::Comics::Command::download;

=head1 NAME

App::Comics::Command::download - Download command

=head1 DESCRIPTION

L<App::Comics::Command::download> comic strips

=cut

use Mojo::Base 'Mojolicious::Command';

use Getopt::Long qw(GetOptionsFromArray :config no_auto_abbrev no_ignore_case);

=head1 METHODS

=head2 run

Run this command.

=cut

sub run {
  my ($self, @args) = @_;

  GetOptionsFromArray \@args,
    'c|comic=s' => \(my $name = ''),
    'd|date=i'  => \my @dates;

  $self->app->comics->dates([(sort @dates)[0,-1]])->recollect;
  my $comics = $name ? $self->app->comics->collection->grepname($name) : $self->app->comics->collection;

  foreach my $comic ( $comics->each ) {
    say sprintf "Comic: %s", $comic->name;
    foreach my $strip ( $comic->strips->collection->grep(sub{!$_->exists})->each ) {
      say sprintf "Date: %s", $strip->date;
      say sprintf "Abs Path: %s", $strip->abs_path;
    }
 }

  return 0;
}

=head1 COPYRIGHT

Stefan Adams

=head1 AUTHOR

Stefan Adams - C<stefan@borgia.com>

=cut

1;
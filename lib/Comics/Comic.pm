package Comics::Comic;
use Mojo::Base 'Comics::Core'; 

use Comics::Strips;

has name => 'Sample';
has link => 'http://samp.le';
has strips => sub { Comics::Strips->new(comic => shift) };

1;

package Comics::Library;
use Mojo::Base 'Comics::Core';

our $VERSION = '0.01';

use Comics::Date;
use Comics::Comics;

has comic => sub { croak 'Not implemented' };
has dates => sub { [] };
has namespace => join '::', __PACKAGE__, 'Comic';
has order => sub { [] };

has date => sub { Comics::Date->new(dates => shift->dates) };
has comics => sub { Comics::Comics->new(collection => $self) };

1;

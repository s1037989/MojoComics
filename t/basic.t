use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('Comics');
$t->get_ok('/')->status_is(200)->content_like(qr/Date: \d{8}/i);
$t->get_ok('/20140812')->status_is(200)->content_like(qr/Date: 20140812/i);
$t->get_ok('/sample')->status_is(200)->content_like(qr/Comic: sample/i)->content_like(qr/From: \d{8}/i)->content_like(qr/To: \d{8}/i);
$t->get_ok('/sample/20140812')->status_is(200)->content_like(qr/Comic: sample/i)->content_like(qr/From: 20140812/i)->content_like(qr/To: \d{8}/i);
$t->get_ok('/sample/2014081')->status_is(404);
$t->get_ok('/sample/20140812/20140812')->status_is(200)->content_like(qr/Comic: sample/i)->content_like(qr/From: 20140812/i)->content_like(qr/To: 20140812/i);
$t->get_ok('/sample/20140812/2014081')->status_is(404);

done_testing();

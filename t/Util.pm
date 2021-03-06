package t::Util;
use strict;
use warnings;
use parent 'Exporter';

our @EXPORT = qw(
    send_request receive_request
);

use JSON::XS;
use Furl::HTTP;
use Furl::Response;

sub send_request (&@) {
    my($code, $mock) = @_;
    no warnings 'redefine';
    local *Furl::HTTP::request = sub {
        shift;
        my $ret = $mock->(@_);
        my $json = encode_json $ret;
        return ('0', '200', 'OK', [
            'Content-Type'   => 'application/json; charset=UTF-8',
            'Content-Length' => length($json),
        ], $json);
    };
    $code->();
}
sub receive_request (&) { shift }

1;

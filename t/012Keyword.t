
###########################################
# Keyword search tests
# Mike Schilli, 2004 (m@perlmeister.com)
###########################################
use warnings;
use strict;

use Net::Amazon;
use Net::Amazon::Property;
use Net::Amazon::Request::Keyword;
use Test::More tests => 8;

################################################################
# Setup
################################################################
  my($TESTDIR) = map { -d $_ ? $_ : () } qw(t ../t .);
  require "$TESTDIR/init.pl";
  my $CANNED = "$TESTDIR/canned";
################################################################
  canned($CANNED, "keyword.xml");
################################################################

my $ua = Net::Amazon->new(
    token         => 'YOUR_AMZN_TOKEN',
    max_pages     => 5,
    response_dump => 1,
);

my $req = Net::Amazon::Request::Keyword->new(
    keyword   => "perl power",
    mode      => "books",
);

 # Response: Net::Amazon::Keyword::Response
my $resp = $ua->request($req);

ok($resp->is_success(), "Successful fetch");
my @properties = $resp->properties();
is(scalar @properties, 6, "6 hits");
for ($resp->properties) {
   like $_->Asin(), qr/^\d+[\dX]$/, "Check Asin";
}
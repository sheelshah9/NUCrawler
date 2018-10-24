#!/usr/bin/perl -w
# diary-link-checker - check links from diary page

use strict;
use LWP;
require LWP::UserAgent;
#my $doc_url = "https://news.google.com/search?q=nirma%20university&hl=en-IN&gl=IN&ceid=IN%3Aen";
#my $doc_url = "https://www.bing.com/news/search?q=nirma+university&qft=sortbydate%3d%221%22&form=YFNR";
#my $doc_url = "http://www.nirmauni.ac.in/ITNU/NEWS";
my $doc_url = "https://results.dogpile.com/search/news?q=nirma+university&ql=&topSearchSubmit.x=0&topSearchSubmit.y=0&qlnk=True&fcoid=417&fcop=topnav&fpid=27&om_nextpage=True";
my @urls = ("https://news.google.com/search?q=nirma%20university&hl=en-IN&gl=IN&ceid=IN%3Aen","https://www.bing.com/news/search?q=nirma+university&qft=sortbydate%3d%221%22&form=YFNR","http://www.nirmauni.ac.in/ITNU/NEWS");
my $document;
my @docs = ("Google News", "Bing News", "Nirma Site");
my $browser;
my $i = 0;
init_browser( );

{  # Get the page whose links we want to check:
  foreach my $element (@urls) {
    my $response = $browser->get($element);
  die "Couldn't get $doc_url: ", $response->status_line
    unless $response->is_success;
  $document = $response->content;
  $doc_url = $response->base;
  open(my $fh, '>>', 'report.txt');
  print $fh "---------------$docs[$i]--------------\n";
  close $fh;
  $i++;
  while ($document =~ m/href\s*=\s*"([^"\s]+)"/gi) {
    my $absolute_url = absolutize($1, $doc_url);
    check_url($absolute_url);
  }
  }
  
  # In case we need to resolve relative URLs later
}

sub absolutize {
  my($url, $base) = @_;
  use URI;
  return URI->new_abs($url, $base)->canonical;
}

sub init_browser {
  $browser = LWP::UserAgent->new;
  # ...And any other initialization we might need to do...
  return $browser;
}

sub check_url {
  # A temporary placeholder...
  if (index($_[0], 'bing') != -1 || index($_[0], 'microsoft') != -1 || index($_[0], 'javascript') != -1) {
    print "\n";
  }
  else{
  open(my $fh, '>>', 'report.txt');
  print $fh "$_[0]\n";
  close $fh;
  print "  $_[0]\n";
  }
}

use strict;
use warnings;

sub each_array {

  my @copy = @_;
  my $i;
  my $max;

  for (map scalar @$_, @copy) {
    $max = $_ unless defined $max and $max > $_;
  }

  sub {
    return $i if @_ and shift eq 'index';
    my $new_i = defined $i ? $i + 1 : 0;
    return if $new_i >= $max;
    $i = $new_i;
    return map $_->[$i], @copy;
  }
}
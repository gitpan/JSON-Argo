use warnings;
use strict;
use Test::More;
BEGIN { use_ok('JSON::Argo') };
use JSON::Argo qw/json_to_perl valid_json/;
use utf8;

binmode STDOUT, ":utf8";
my $jason = '{"bog":"log","frog":[1,2,3],"guff":{"x":"y","z":"monkey","t":[0,1,2.3,4,59999]}}';
print "Parsing '$jason'\n";
my $x = gub ($jason);
ok ($x->{guff}->{t}->[2] == 2.3, "Two point three");
print "Finished.\n";

my $fleece = '{"凄い":"技", "tickle":"baby"}';
my $y = gub ($fleece);
ok ($y->{tickle} eq 'baby', "Don't tickle baby");
ok (valid_json ($fleece), "Valid OK JSON");

my $argonauts = '{"medea":{"magic":true,"nice":false}}';
my $z = gub ($argonauts);
ok ($z->{medea}->{magic} eq 'true', "Magic, magic, you can do magic");
ok (! defined ($z->{medea}->{nice}), "Now that's not very nice.");
ok (valid_json ($argonauts), "Valid OK JSON");

# Test that empty inputs result in an undefined return value, and no
# error message.

my $p = json_to_perl (undef);
ok (! defined $p, "Undef returns undef");
ok (! valid_json (undef), "! Valid bad JSON");
my $Q = json_to_perl ('');
ok (! defined $Q, "Empty string returns undef");
ok (! valid_json (''), "! Valid bad JSON");
my $n;
eval {
$n = '{"骪":"\u9aaa"';
my $nar = json_to_perl ($n);
};
ok ($@, "found error");
ok ($@ =~ /not grammatically correct/, "Error message OK");
ok (! valid_json ($n), "! Valid bad JSON");
my $m = '{"骪":"\u9aaa"}';
my $ar = json_to_perl ($m);
ok (defined $ar, "Unicode \\uXXXX parsed");
ok ($ar->{骪} eq '骪', "Unicode \\uXXXX parsed correctly");
ok (valid_json ($m), "Valid good JSON");
my $bad1 = '"bad":"city"}';
eval {
    json_to_perl ($bad1);
};
ok ($@, "found error in '$bad1'");
ok ($@ =~ /did not start/, "Error message as expected");
my $notjson = 'this is not lexable';
eval {
    json_to_perl ($notjson);
};
ok ($@, "Got error message");
ok ($@ =~ /stray characters/i, "unlexable message OK");
ok (! valid_json ($notjson), "Not valid bad json");

my $wi =<<EOF;
{
     "firstName": "John",
     "lastName": "Smith",
     "age": 25,
     "address":
     {
         "streetAddress": "21 2nd Street",
         "city": "New York",
         "state": "NY",
         "postalCode": "10021"
     },
     "phoneNumber":
     [
         {
           "type": "home",
           "number": "212 555-1234"
         },
         {
           "type": "fax",
           "number": "646 555-4567"
         }
     ]
 }
EOF
my $xi = json_to_perl ($wi);
ok ($xi->{address}->{postalCode} eq '10021', "Test a value");
ok (valid_json ($wi), "Validate");

done_testing ();
exit;

sub gub
{
    my ($json) = @_;
    my $p = json_to_perl ($json);
#    print "$p\n";
# Uncommend this to bugger things up
#    blub ($p);
    return $p;
}

sub blub
{
    my ($w, $indent) = @_;
    if (! defined $indent) {
        $indent = 0;
    }
    if (ref $w eq 'ARRAY') {
        indent ($indent, "[");
        for my $e (@$w) {
            blub ($e, $indent+1);
        }
        indent ($indent, "]");
    }
    elsif (ref $w eq 'HASH') {
        indent ($indent, "{");
        for my $k (keys %$w) {
            indent ($indent, "$k:");
            blub ($w->{$k}, $indent+1);
        }
        indent ($indent, "}");
    }
    else {
        indent ($indent, $w);
    }
}

sub indent
{
    my ($indent, $w) = @_;
    print "  " x $indent;
    print "$w\n";
}

# Local variables:
# mode: perl
# End:

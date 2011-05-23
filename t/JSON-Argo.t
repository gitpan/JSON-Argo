use warnings;
use strict;
use Test::More;
BEGIN { use_ok('JSON::Argo') };
use JSON::Argo 'json_to_perl';
use utf8;

binmode STDOUT, ":utf8";
my $jason = '{"bog":"log","frog":[1,2,3],"guff":{"x":"y","z":"monkey","t":[0,1,2.3,4,59999]}}';
my $x = gub ($jason);
ok ($x->{guff}->{t}->[2] == 2.3, "Two point three");

my $fleece = '{"凄い":"技", "tickle":"baby"}';
my $y = gub ($fleece);
ok ($y->{tickle} eq 'baby', "Don't tickle baby");

my $argonauts = '{"medea":{"magic":true,"nice":false}}';
my $z = gub ($argonauts);
ok ($z->{medea}->{magic} eq 'true', "Magic, magic, you can do magic");
ok (! defined ($z->{medea}->{nice}), "Now that's not very nice.");

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

package JSON::Argo;
require Exporter;
@ISA = qw(Exporter);
@EXPORT_OK = qw/json_to_perl valid_json/;
use warnings;
use strict;
our $VERSION = 0.03;
use XSLoader;
XSLoader::load 'JSON::Argo', $VERSION;

1;

__END__

=pod

=head1 NAME

JSON::Argo - Convert JSON into a Perl variable

=head1 SYNOPSIS

    use JSON::Argo 'json_to_perl';
    my $json = '["golden", "fleece"]';
    my $perl = json_to_perl ($json);
    # Same as if $perl = ['golden', 'fleece'];

Convert JSON (JavaScript Object Notation) into Perl.

=head1 FUNCTIONS

=head2 valid_json

    if (valid_json ($json)) {
        # do something
    }

This function returns 1 if its argument is valid JSON and 0 if its
argument is not valid JSON.

=head2 json_to_perl

    my $perl = json_to_perl ('{"x":1, "y":2}');

This function converts JSON into a Perl structure. 

=head3 Return value

If the first argument does not contain a valid JSON text, the return
value is the undefined value.

If the first argument contains a valid JSON text, the return value is
either a hash reference or an array reference, depending on whether
the input JSON text is a serialized object or a serialized array.

=head3 Mapping from JSON to Perl

The following mapping is done from JSON to Perl:

=over

=item JSON numbers

JSON numbers are mapped to Perl scalars. The JSON number is inserted
into Perl as a string. Conversion from the character string to a
numerical value is left to Perl.

=item JSON strings

JSON strings are mapped to Perl scalars as strings. JSON escape
characters (see page five of L</RFC 4267>) are mapped to the
equivalent ASCII character before they are passed to Perl.

=item JSON arrays

JSON arrays are mapped to Perl arrays, with elements in the same order
as they appear in the JSON.

=item JSON objects

JSON objects are mapped to Perl hashes (associative arrays). The
members of the object are mapped to pairs of key and value in the Perl
hash. The string part of each member is mapped to the key of the Perl
hash. The value part of each member is mapped to the value of the Perl
hash.

=item null

The JSON null literal is mapped to the undefined value.

=item true

The JSON true literal is mapped to a Perl string with the value 'true'.

=item false

The JSON false literal is mapped to the undefined value.

=back

=head1 BUGS

This is a preliminary version of the module. I know of the following
deficiencies. These will hopefully be resolved in a later version of
the module.

=over

=item UTF-8 only

This module only parses JSON text in the UTF-8 format. This is a
restriction on the permissible bytes of the input text and is
regardless of whether Perl thinks that the text is in UTF-8 format.

=item False == null == undefined value

At the moment, both of "false" and "null" in JSON are mapped to the
undefined value. "true" is mapped to the string "true".

=item Numbers not checked

The author of this module has no idea whether JSON floating point
numbers are invariably understood by Perl (see L</JSON numbers>
above).

=item Name clash

The name of this Perl package (Argo) clashes with a Java JSON
parser. The two things are totally unrelated. The author of this
module only found out about the Java program after already uploading
this module to CPAN.

=item Line numbers

The line numbers are broken since switching to a reentrant parser.

=back

=head1 DIAGNOSTICS

The possible error messages of the parser can be seen in the file
F<json_parse.c> in the top level of the distribution.

Errors are fatal, so if you need to continue after an error occurs, you should put the parsing into its own block:

    my $p;                       
    eval {                       
        $p = json_to_perl ($j);  
    };                           
    if ($@) {                    
        # handle error           
    }

=head1 SEE ALSO

=over

=item RFC 4627

JSON is specified in RFC (Request For Comments, a kind of internet
standards document) 4627. See, for example,
L<http://www.ietf.org/rfc/rfc4627.txt>.

=back

=head1 HOW IT WORKS

JSON::Argo is based on a parser written in C. The C parser makes use
of the utilities Bison and Flex. The C parser is reentrant, in other
words thread-safe.

JSON::Argo will only parse JSON which meets the criteria of L</RFC
4267>. It will only accept non-ASCII characters if they are in the
UTF-8 encoding. JSON::Argo does not do incremental parsing. JSON::Argo
will only parse a fully-formed JSON string.

=head1 SOURCES

C files in the distribution are the outputs of the "bison" and "flex"
programs. The original inputs to the "bison" and "flex" programs may
be found in the directory "src" of the distribution. These are not
necessary to build the Perl module. The user does not need to have
installed either "bison" or "flex" to build this module. These inputs
are included in the distribution to comply with the requirements of
the GNU General Public License.

=head1 AUTHOR

Ben Bullock, <bkb@cpan.org>

=head1 LICENSE

You can use, copy, modify and redistribute JSON::Argo under the same
terms as Perl itself.

=cut


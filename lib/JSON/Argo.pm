package JSON::Argo;
require Exporter;
@ISA = qw(Exporter);
@EXPORT_OK = qw/json_to_perl/;
use warnings;
use strict;
our $VERSION = 0.01;
use XSLoader;
XSLoader::load 'JSON::Argo', $VERSION;

1;

__END__

=pod

=head1 NAME

JSON::Argo - Convert JSON text into Perl

=head1 SYNOPSIS

    use JSON::Argo 'json_to_perl';
    my $json = '["golden", "fleece"]';
    my $perl = json_to_perl ($json);
    # Same as if $perl = ['golden', 'fleece'];

Convert JSON (JavaScript Object Notation) into Perl.

=head1 FUNCTIONS

=head2 json_to_perl

    my $perl = json_to_perl ('{"x":1, "y":2}');

This function converts JSON into a Perl structure. The following
mapping is done from JSON to Perl:

=over

=item JSON numbers

JSON numbers are mapped to Perl scalars. This conversion is done by
inserting the component characters of the JSON as strings, leaving
conversion from the character string to a numerical value to Perl
itself.

=item JSON strings

JSON strings are mapped to Perl scalars as strings. JSON escape
characters (see page five of L</RFC 4267>) are mapped to the
equivalent ASCII character before they are passed to Perl.

=item JSON arrays

JSON arrays are mapped to Perl arrays, with elements in the same order
as they appear in the JSON.

=item JSON objects

JSON objects are mapped to Perl hashes (associative arrays).

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
regardless of whether or not Perl thinks that the text is in UTF-8
format or not.

=item No error recovery

This module features no error recovery.

=item False == null == undefined value

At the moment, both of "false" and "null" in JSON are mapped to the
undefined value. "true" is mapped to the string "true".

=item No uXXXX

A Unicode "four hex digit" (see page four of L</RFC 4627>) causes an
error.

=back

=head1 DIAGNOSTICS

The possible error messages of the parser can be seen in the file
F<json_parse.c> in the top level of the distribution.

=head1 SEE ALSO

=over

=item RFC 4627

JSON is specified in RFC (Request For Comments, a kind of internet
standards document) 4627. See, for example,
L<http://www.ietf.org/rfc/rfc4627.txt>.

=back

=head1 SOURCES

C files in the distribution are the outputs of the "bison" and "flex"
programs. The original inputs to the "bison" and "flex" programs may
be found in the directory "src" of the distribution. These are not
necessary in order to build the Perl module. The user does not need to
have installed either "bison" or "flex" to build this module. These
inputs are included in the distribution in order to comply with the
requirements of the GNU General Public License.

=head1 AUTHOR

Ben Bullock, <bkb@cpan.org>

=head1 LICENSE

You can use, copy, modify and redistribute JSON::Argo under the same
terms as Perl itself.

=cut


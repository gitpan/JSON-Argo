use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile (
    NAME => 'JSON::Argo',
    VERSION_FROM => 'lib/JSON/Argo.pm',
    OBJECT => 'Argo.o json_argo.o json_parse.o json_parse_lexer.o json_parse_grammar.tab.o unicode.o',
    LICENSE => 'perl',
    AUTHOR => 'Ben Bullock <bkb@cpan.org>',
    # I am setting the following experimentally. BKB 2011-05-30 10:38:10
    PERL_MALLOC_OK => 1,
);

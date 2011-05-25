use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile (
    NAME => 'JSON::Argo',
    VERSION_FROM => 'lib/JSON/Argo.pm',
    OBJECT => 'Argo.o json_argo.o json_parse.o json_parse_lexer.o json_parse_grammar.tab.o unicode.o',
    LICENSE => 'perl',
);

/* Copyright (c) 2010-2011 Ben Bullock (bkb@cpan.org). */

#include <stdio.h>
#include <stdlib.h>

#ifdef HEADER

typedef enum {
    json_parse_ok,
    json_parse_fail,
    json_parse_callback_fail,
    json_parse_memory_fail,
    json_parse_grammar_fail,
    json_parse_lex_fail,
    json_parse_unimplemented_fail,
    json_parse_unicode_fail,
    json_parse_no_input_fail,
    json_parse_bad_start_fail,
    json_parse_unknown_escape_fail,
    json_parse_n_statuses,
} 
json_parse_status;

typedef enum {
    json_null,
    json_true,
    json_false
} 
json_type;

/* User object */
typedef void * json_parse_u_obj;

/* User data */
typedef void * json_parse_u_data;

/* Place for user to return a newly-created object */
typedef json_parse_u_obj * json_parse_new_u_obj;

/* Function types */
typedef json_parse_status 
(*json_parse_create_sn)
(json_parse_u_data, const char *, json_parse_new_u_obj);
typedef json_parse_status 
(*json_parse_create_ao)
(json_parse_u_data, json_parse_new_u_obj);
typedef json_parse_status
(*json_parse_create_ntf)
(json_parse_u_data, json_type, json_parse_new_u_obj);
typedef json_parse_status
(*json_parse_add2array)
(json_parse_u_data, json_parse_u_obj a, json_parse_u_obj e);
typedef json_parse_status
(*json_parse_add2object)
(json_parse_u_data, json_parse_u_obj o, json_parse_u_obj l, json_parse_u_obj r);

typedef struct {
    json_parse_create_sn string_create;
    json_parse_create_sn number_create;
    json_parse_create_ao array_create;
    json_parse_create_ao object_create;
    json_parse_create_ntf ntf_create;
    json_parse_add2array array_add;
    json_parse_add2object object_add;
    /* The data to be passed in to the above routines. */
    json_parse_u_data ud;
    /* The end-result of the parsing. */
    json_parse_u_obj parse_result;
    /* The status of the parser at the end of parsing. */
    json_parse_status js;
    /* Holder for the flex scanner. */
    void * scanner;
    /* Buffer for reading strings in Flex. */
    struct {
        size_t size;
        size_t length;
        char * chrs;
    } buffer;
}
json_parse_object;

#endif

#include "json_parse.h"
#include "json_parse_grammar.tab.h"
#include "json_parse_lexer.h"

const char * json_parse_status_messages[json_parse_n_statuses] = {
    "OK",
    "unknown failure",
    "a callback routine failed",
    "out of memory",
    "parser failed (this JSON is not grammatically correct)",
    "lexer failed (there are stray characters in the input)",
    "unimplemented feature of JSON encountered in input",
    "Unicode \\uXXXX decoding failed",
    "input was empty",
    "the text did not start with { or [ as it should have",
    "met an unknown escape sequence (backslash \\ + character)",
};

/* This declares the parsing function in
   "json_parse_grammar.tab.c". */

int json_parse_parse (json_parse_object * jpo);

/* With the reentrant parser, it is necessary to initialize the
   buffers which are in jpo->scanner. This also sets the value of
   yyextra to jpo. */

void json_parse_init (json_parse_object * jpo)
{
    json_parse_lex_lex_init (& jpo->scanner);
    json_parse_lex_set_extra (jpo, jpo->scanner);
}

/* This is the main entry point of the routine. */

int json_parse (json_parse_object * jpo)
{
    int parser_status;
    parser_status = json_parse_parse (jpo);
    return parser_status;
}

void json_parse_free (json_parse_object * jpo)
{
    if (jpo->buffer.chrs) {
        free (jpo->buffer.chrs);
    }
    json_parse_lex_lex_destroy (jpo->scanner);
}

/* This is the error handler required by yacc/bison. What it does is
   to correctly set the error status in the user's object. The client
   of this parser then decides what to do about the error. */

int json_parse_error (json_parse_object * jpo_x, const char * message)
{
    if (jpo_x->js == json_parse_ok)
	jpo_x->js = json_parse_grammar_fail;
    return 0;
}

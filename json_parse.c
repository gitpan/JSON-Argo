#include <stdio.h>

#ifdef HEADER

typedef enum {
    json_parse_ok,
    json_parse_fail,
    json_parse_callback_fail,
    json_parse_memory_fail,
    json_parse_parse_fail,
    json_parse_lex_fail,
    json_parse_unimplemented_fail
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
} json_parse_object;

#endif

const char * json_parse_status_messages[] = {
    "OK",
    "unknown failure",
    "a callback routine failed",
    "out of memory",
    "parser failed (this JSON is not grammatically correct)",
    "lexer failed (there are stray characters in the input)",
    "unimplemented feature of JSON encountered in input"
};

#include "json_parse.h"

json_parse_object * json_parse_global_jpo;

int json_parse_parse();

/* This is the main entry point of the routine. */

int json_parse (json_parse_object * jpo)
{
    int parser_status;
    json_parse_global_jpo = jpo;
    json_parse_global_jpo->js = json_parse_ok;
    parser_status = json_parse_parse();
    json_parse_global_jpo = 0;
    return parser_status;
}

/* This is the error handler required by yacc/bison. What it does is
   to correctly set the error status in the user's object. The client
   of this parser then decides what to do about the error. */

int json_parse_error (const char * message)
{
    if (json_parse_global_jpo->js == json_parse_ok)
	json_parse_global_jpo->js = json_parse_fail;
    return 0;
}

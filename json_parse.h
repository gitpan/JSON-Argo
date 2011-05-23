/* This is a Cfunctions (version 0.27) generated header file.
   Cfunctions is a free program for extracting headers from C files.
   Get Cfunctions from `http://cfunctions.sourceforge.net/'. */

/* This file was generated with:
`/home/ben/software/install/bin/cfunctions -in json_parse.c' */
#ifndef CFH_JSON_PARSE_H
#define CFH_JSON_PARSE_H

/* From `json_parse.c': */

#line 3 "json_parse.c"
typedef enum {
    json_parse_ok,
    json_parse_fail,
    json_parse_callback_fail,
    json_parse_memory_fail,
    json_parse_parse_fail,
    json_parse_lex_fail,
    json_parse_unimplemented_fail
}
#line 14 "json_parse.c"
json_parse_status;
typedef enum {
    json_null,
    json_true,
    json_false
}
#line 21 "json_parse.c"
json_type;

#line 23 "json_parse.c"
typedef void * json_parse_u_obj;

#line 25 "json_parse.c"
typedef void * json_parse_u_data;

#line 27 "json_parse.c"
typedef json_parse_u_obj * json_parse_new_u_obj;

#line 30 "json_parse.c"
typedef json_parse_status (*json_parse_create_sn)
(json_parse_u_data, const char *, json_parse_new_u_obj);

#line 33 "json_parse.c"
typedef json_parse_status (*json_parse_create_ao)
(json_parse_u_data, json_parse_new_u_obj);

#line 36 "json_parse.c"
typedef json_parse_status (*json_parse_create_ntf)
(json_parse_u_data, json_type, json_parse_new_u_obj);

#line 39 "json_parse.c"
typedef json_parse_status (*json_parse_add2array)
(json_parse_u_data, json_parse_u_obj a, json_parse_u_obj e);

#line 42 "json_parse.c"
typedef json_parse_status (*json_parse_add2object)
(json_parse_u_data, json_parse_u_obj o, json_parse_u_obj l, json_parse_u_obj r);
typedef struct {
    json_parse_create_sn string_create;
    json_parse_create_sn number_create;
    json_parse_create_ao array_create;
    json_parse_create_ao object_create;
    json_parse_create_ntf ntf_create;
    json_parse_add2array array_add;
    json_parse_add2object object_add;
    
    json_parse_u_data ud;
    
    json_parse_u_obj parse_result;
    
    json_parse_status js;
} 

#line 59 "json_parse.c"
json_parse_object;

#line 71 "json_parse.c"
extern const char * json_parse_status_messages[];

#line 75 "json_parse.c"
extern json_parse_object * json_parse_global_jpo;

#line 82 "json_parse.c"
int json_parse (json_parse_object * jpo );

#line 96 "json_parse.c"
int json_parse_error (const char * message );

#endif /* CFH_JSON_PARSE_H */
/* JSON parser */

%{

#include "json_parse_lexer.h"
#include "json_parse.h"
#define CALL(f) json_parse_status js; js = (*json_parse_global_jpo->f)
#define CALL2(f) js = (*json_parse_global_jpo->f)

    /* Check the return value from a call to a */

#define CHK if (js != json_parse_ok) {          \
        json_parse_global_jpo->js = js;         \
        return 1;                               \
    }

#define UD json_parse_global_jpo->ud
extern const char * chrs;

%}

%union {
    json_parse_u_obj	  uo;
    json_parse_u_obj 	  uo_pair[2];
    const char *  chrs;
}

%name-prefix "json_parse_"

%token <chrs> chars
%token <chrs> number
%token true
%token false
%token null
%type <uo> json
%type <uo> object
%type <uo> array
%type <uo> _pairs
%type <uo> _value
%type <uo> string
%type <uo> _list
%type <uo_pair> _pair

%%

json:	object	                { json_parse_global_jpo->parse_result = $$ }
	| array			{ json_parse_global_jpo->parse_result = $$ }

object: '{' _pairs '}'		{ $$ = $2; }

_pairs:	/* empty */		{ CALL(object_create)(UD, & $$); CHK }
	| _pair	 		{ CALL(object_create)(UD, & $$); CHK
	  			  CALL2(object_add)(UD, $$, $1[0], $1[1]); CHK }
	| _pairs ',' _pair	{ CALL(object_add)(UD, $1, $3[0], $3[1]); CHK 
                                  $$ = $1; }

_pair:	string ':' _value	{ $$[0] = $1; $$[1] = $3; }

string: chars                   { CALL(string_create)(UD, $1, & $$); CHK }

array:	'[' _list ']'		{ $$ = $2; }

_list:	/* empty */		{ CALL(array_create)(UD, & $$); CHK }
	| _value		{ CALL(array_create)(UD, & $$); CHK 
	  			  CALL2(array_add)(UD, $$, $1); CHK }
	| _list ',' _value	{ CALL(array_add)(UD, $1, $3); CHK; $$ = $1; }

_value:	chars	    		{ CALL(string_create)(UD, $1, & $$); CHK }
	| number	    	{ CALL(number_create)(UD, $1, & $$); CHK }
	| object
	| array
	| true			{ CALL(ntf_create)(UD, json_true, & $$); CHK }
	| false			{ CALL(ntf_create)(UD, json_false, & $$); CHK }
	| null			{ CALL(ntf_create)(UD, json_null, & $$); CHK }

%%
%{

#include <string.h>
#include <stdlib.h>
#include "json_parse.h"
#include "json_parse_grammar.tab.h"

static struct {
    size_t size;
    size_t length;
    char * chrs;
} _buffer = {0,0,0};

#define BASE_SIZE 0x400

#define CALL(function) {json_parse_status js=function; \
	if (js != json_parse_ok) return js;}

static json_parse_status
_buffer_resize()
{
    int i;
    if (_buffer.length == 0) {
        _buffer.chrs = malloc (BASE_SIZE);
	if (! _buffer.chrs)
	    return json_parse_memory_fail;
	_buffer.size = BASE_SIZE;
    } else {
        size_t new_size = _buffer.size * 2;
	_buffer.chrs = realloc (_buffer.chrs, new_size);
	if (! _buffer.chrs)
	    return json_parse_memory_fail;
	_buffer.size = new_size;	
    }
    for (i=_buffer.length;i<_buffer.size;i++)
        _buffer.chrs[i] = '\0';
    return json_parse_ok;
}

static json_parse_status
_buffer_add(char c)
{
    size_t new_length = _buffer.length + 1;
    if (new_length >= _buffer.size) {
	CALL(_buffer_resize());
    }
    _buffer.chrs[_buffer.length] = c;
    _buffer.length = new_length;
    return json_parse_ok;
}

#define ADD(n) _buffer_add(yytext[n])

static json_parse_status
_buffer_finish()
{
    _buffer.chrs[_buffer.length]= '\0';
    _buffer.length = 0;
    json_parse_lval.chrs = _buffer.chrs;
    return json_parse_ok;
}

/* See RFC 4267 p.5. */

static json_parse_status
_buffer_add_escape (char c)
{
    switch (c) {
    case '"':	return _buffer_add(c);
    case '\\':	return _buffer_add(c);
    case '/':	return _buffer_add(c);
    case 'b':	return _buffer_add(8);
    case 'f':	return _buffer_add(12);
    case 'n':	return _buffer_add(10);
    case 'r':	return _buffer_add(13);
    case 't':	return _buffer_add(9);
    default:	return json_parse_lex_fail;
    }
}

static json_parse_status
_buffer_copy_yytext ()
{
    size_t length = strlen (yytext);
    while (length >= _buffer.size) {
	CALL(_buffer_resize());
    }
    strcpy (_buffer.chrs, yytext);
    _buffer.length = length;
    return _buffer_finish ();
}

#define FAIL(failure) json_parse_global_jpo->js = failure; return -1;
static json_parse_status js;
#define CHK if (js != json_parse_ok) {FAIL(js)}

%}

%option noyywrap

 /* See Flex manual, section 16.3 */

%option prefix="json_parse_"

 /* See RFC 4267 p.4 */

NUMBER  -?([1-9][0-9]*|0)(\.[0-9]+)?([eE][-+]?[0-9]+)?

 /* See RFC 4267 p.5 */

ESCAPE	\\["\\/bfnrt]

/* See RFC 4267 p.2 */

WSPACE  [\x09\x0A\x0D\x20]

UNICODE \\u[0-9a-fA-F]{4}

UTF8_2	[\xC2-\xDF][\x80-\xBF]
UTF8_3  [\xE1-\xEF][\x80-\xBF]{2}
UTF8_4	[\xF0-\xF4][\x80-\xBF]{3}

%s STRING 

%%

<INITIAL>[\[\]{},:]	{ return yytext[0]; }
<INITIAL>\"		{ BEGIN(STRING); }
<INITIAL>{NUMBER}	{ js = _buffer_copy_yytext (); CHK; return number; }
<INITIAL>{WSPACE}	{ }
<INITIAL>true		{ return true; }
<INITIAL>false		{ return false; }
<INITIAL>null		{ return null; }
<INITIAL>.		{ FAIL(json_parse_lex_fail) }
<STRING>\"	  	{ js = _buffer_finish (); CHK; 
                          BEGIN(INITIAL); return chars; }
<STRING>[\x20-\x7E]	{ ADD(0); }
<STRING>{ESCAPE}	{ js = _buffer_add_escape (yytext[1]); CHK }
<STRING>{UNICODE}	{ FAIL(json_parse_unimplemented_fail) }
<STRING>{UTF8_2}	{ ADD(0); ADD(1); }
<STRING>{UTF8_3}	{ ADD(0); ADD(1); ADD(2); }
<STRING>{UTF8_4}	{ ADD(0); ADD(1); ADD(2); ADD(3); }
<STRING>.		{ FAIL(json_parse_lex_fail); }

%%

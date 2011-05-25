#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include "json_parse.h"
#include "json_argo.h"

MODULE = JSON::Argo     PACKAGE = JSON::Argo

PROTOTYPES: ENABLE

SV * json_to_perl (SV * json)
CODE:
RETVAL = json_argo_to_perl (json);
OUTPUT:
RETVAL

int valid_json (SV * json)
CODE:
RETVAL = json_argo_valid_json (json);
OUTPUT:
RETVAL


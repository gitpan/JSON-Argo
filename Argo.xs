#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include "json_argo.h"

MODULE = JSON::Argo     PACKAGE = JSON::Argo

PROTOTYPES: ENABLE

SV * json_to_perl (SV * json)
CODE:
RETVAL = json_argo_to_perl (json);
OUTPUT:
RETVAL


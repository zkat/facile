! Copyright (C) 2010 Kat Marchán
! See http://factorcode.org/license.txt for BSD license.
USING: kernel stack-checker words compiler.units json.writer json.reader io arrays eval
namespaces sequences ;

IN: couchdb-view-server

SYMBOL: quots
SYMBOL: config
SYMBOL: map-results

quots [ { } ] initialize
map-results [ { } ] initialize

: respond ( response -- ) >json print ;

: emit ( array -- ) map-results swap [ prefix ] curry change ;

: log ( string -- ) "Factor View Server: " swap append "log" swap 2array >json print flush ;

: add-quot ( string -- ) eval( -- quot ) quots [ swap prefix ] change t respond ;

: reset ( -- ) { } quots set t respond ;

: call-map-quot ( doc quot -- result )
    { } map-results
    [ call( doc -- ) map-results get ] with-variable ;

: map-doc ( doc -- ) quots get swap [ swap call-map-quot ] curry map respond ;

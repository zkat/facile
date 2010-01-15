! Copyright (C) 2010 Kat Marchán
! See http://factorcode.org/license.txt for BSD license.
USING: kernel stack-checker words compiler.units json.writer json.reader io arrays eval
namespaces sequences ;

IN: couchdb-view-server

SYMBOL: quots
SYMBOL: config
SYMBOL: map-results

quots [ { } ] initialize

: respond ( response -- ) >json print flush ;

: emit ( array -- ) map-results swap [ prefix ] curry change ;

: (log) ( string -- response ) "Factor View Server: " prepend "log" swap 2array ;

: log ( string -- ) (log) respond ;

: add-quot ( string -- ) eval( -- quot ) quots [ swap prefix ] change-global t respond;

: reset ( -- ) { } quots set t respond ;

: call-map-quot ( doc quot -- result )
    { } map-results
    [ call( doc -- ) map-results get ] with-variable ;

: (map-doc) ( doc -- results ) quots get-global swap [ swap call-map-quot ] curry map ;

: map-doc ( doc -- ) (map-doc) respond ;

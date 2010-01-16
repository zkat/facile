! Copyright (C) 2010 Kat Marchán
! See http://factorcode.org/license.txt for BSD license.
USING: kernel stack-checker words compiler.units json.writer json.reader io arrays eval
namespaces sequences assocs ;

IN: facile

SYMBOL: quots
SYMBOL: config
SYMBOL: map-results

quots [ { } ] initialize

: respond ( response -- ) >json print flush ;

: emit ( array -- ) map-results swap [ prefix ] curry change ;

: (log) ( string -- response ) "Factor View Server: " prepend "log" swap 2array ;

: log ( string -- ) (log) respond ;

: (map-doc) ( doc -- results ) quots get-global swap [ swap call-map-quot ] curry map ;

: call-map-quot ( doc quot -- result )
    { } map-results
    [ call( doc -- ) map-results get ] with-variable ;

: true-respond ( response -- ) t swap 2array respond ;

: split-kv ( keys-and-values -- values keys ) unzip swap keys ;

: (reduce-results) ( quot-strings keys-and-values -- reductions )
    split-kv rot f swap
    [ eval( -- quot ) call( values keys rereduce? -- reduction ) ]
    with with with map ;

: (rereduce) ( quot-strings values -- results )
    { } rot t swap
    [ eval( -- quot ) call( values keys rereduce? -- reduction ) ]
    with with with map ;

: (filter-docs) ( docs req user-context -- response ) 2drop ; ! todo

: add-quot ( string -- ) eval( -- quot ) quots [ swap prefix ] change-global t respond ;

: reset ( args -- ) quots set t respond ;

: map-doc ( args -- ) first (map-doc) respond ;

: reduce-results ( args -- ) first2 (reduce-results) true-respond ;

: rereduce ( args -- ) first2 (rereduce) true-respond ;

: filter-docs ( args -- ) first3 (filter-docs) true-respond ;

: validate ( args -- ) first4 2drop 2drop ; ! todo

: show ( args -- ) first3 3drop ; ! todo

: update ( args -- ) first3 3drop ; ! todo

!
! View server
!
SYMBOL: dispatch-table
dispatch-table [
    {
        { "reset" [ reset ] }
        { "add_fun" [ add-quot ] }
        { "map_doc" [ map-doc ] }
        { "reduce" [ reduce-results ] }
        { "rereduce" [ rereduce ] }
        { "filter" [ filter-docs ] }
        { "validate" [ validate ] }
        { "show" [ show ] }
        { "update" [ update ] }
        ! { "list" [ couch-list ] }
    }
] initialize

: dispatch-command ( name -- quot ) dispatch-table get-global at ;

: next-line ( -- args cmd-name )
    readln dup empty?
    [ json> [ rest ] [ first ] bi swap ]
    [ drop next-line ]
    if ;

: run-server ( -- )
    [
        next-line dispatch-command call t
    ]
    loop ;

MAIN: run-server

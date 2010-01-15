! Copyright (C) 2010 Your name.
! See http://factorcode.org/license.txt for BSD license.
USING: tools.test couchdb-view-server namespaces kernel io strings ;
IN: couchdb-view-server.tests

[ t ]
[
    { } map-results set { 1 2 } emit map-results get
    { { 1 2 } } =
] unit-test

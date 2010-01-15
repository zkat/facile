! Copyright (C) 2010 Kat Marchán
! See http://factorcode.org/license.txt for BSD license.
USING: tools.test facile namespaces kernel io strings ;
IN: facile.tests

[ t ]
[
    { } map-results set { 1 2 } emit map-results get
    { { 1 2 } } =
] unit-test

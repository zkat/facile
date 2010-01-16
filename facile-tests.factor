! Copyright (C) 2010 Kat Marchán
! See http://factorcode.org/license.txt for BSD license.
USING: tools.test facile namespaces kernel io strings sequences ;
IN: facile.tests

[ t ]
[
    { } map-results set { 1 2 } emit map-results get
    { { 1 2 } } =
] unit-test

[ t ]
[
    { "USING: kernel math sequences ; [ 2drop 0 [ + ] reduce ]" }
    {
        { { "foo" "aoeuaoeu" } 1 }
        { { "bar" "aoeuaoeu" } 1 }
    }
    (reduce-results)
    0 swap nth 2 =
] unit-test

! We want to be able to evaluate the strings in a particular vocabulary.
[ t ]
[
    { "[ 2drop 0 [ + ] reduce ]" }
    {
        { { "foo" "aoeuaoeu" } 1 }
        { { "bar" "aoeuaoeu" } 1 }
    }
    (reduce-results)
    0 swap nth 2 =
] unit-test
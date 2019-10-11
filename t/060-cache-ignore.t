use lib 'lib';
use Test;
use Pod::To::Cached;
use File::Directory::Tree;

plan *;

constant REP = 't/tmp/ref-ignore'.IO;
constant DOC = 't/tmp/doc-ignore'.IO;
constant IGNORE_FILE = ".cache-ignore".IO;

mkdir DOC.IO;

my Pod::To::Cached $cache;
diag 'Test .cache-ignore file';

DOC.IO.add('test1.pod6').spurt(q:to/CONTENT/);
    =begin pod
    =end pod
CONTENT

DOC.IO.add('test2.pod6').spurt(q:to/CONTENT/);
    =begin pod
    =end pod
CONTENT

#--MARKER-- Test 1
$cache .= new( :source( DOC ), :path( REP ), :!verbose);
subtest {
    ok "t/tmp/doc-ignore/test1.pod6".IO ~~ $cache.get-pods.sort[0].IO;
    ok "t/tmp/doc-ignore/test2.pod6".IO ~~ $cache.get-pods.sort[1].IO;
    is $cache.get-pods.elems, 2, 'Only two files are present';
}, IGNORE_FILE ~ " does not exist";

##--MARKER-- Test 2
IGNORE_FILE.IO.spurt("");
$cache .= new( :source( DOC ), :path( REP ), :!verbose);

subtest {
    ok "t/tmp/doc-ignore/test1.pod6".IO ~~ $cache.get-pods.sort[0].IO;
    ok "t/tmp/doc-ignore/test2.pod6".IO ~~ $cache.get-pods.sort[1].IO;
    is $cache.get-pods.elems, 2, 'Only two files are present';
}, IGNORE_FILE ~ " is empty";
unlink IGNORE_FILE;

rmtree REP;
rmtree DOC;

done-testing;

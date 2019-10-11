# assumes that there are directories REP and DOC left from tests in 040
use lib 'lib';
use Test;
use Test::Output;
use Pod::To::Cached;
use File::Directory::Tree;

constant REP = 't/tmp/ref'.IO;
constant DOC = 't/tmp/doc'.IO;
constant COUNT = 3; # number of caches to create

diag "Create multiple ({ COUNT }) caches";

rmtree REP;

my @caches;

for ^COUNT {
    lives-ok {
        @caches[$_] = Pod::To::Cached.new( :source( DOC ), :path( REP.add($_) ), :!verbose)
    }, "created cache no $_";
    lives-ok {
        @caches[$_].update-cache
    }, "update cache no $_";
}

for ^COUNT {
    ok (REP.add($_ )).d;
}

done-testing;

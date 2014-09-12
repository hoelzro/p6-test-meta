# Test::Meta

A testing module to test other testing modules.

# Usage

```perl6

use Test::Meta;
use Test;

plan 2;

test({
    pass 'hello';
}).ok\
  .name('hello');

```

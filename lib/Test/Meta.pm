class Test::Meta {
    submethod BUILD(:$code) {
        # XXX run the code
    }
}

macro test($block) is export {
    my $code = $block.Str ~ '()';
    return quasi { Test::Meta.new(:$code) }
}

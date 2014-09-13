use v6;
use File::Temp;
use TAP::Parser;
use Test;

class Test::Meta {
    has $!tap-result;

    submethod BUILD(:$code) {
        my ( $input, $input_h ) = tempfile(:!unlink);
        my ( $output, $output_h ) = tempfile;

        $input_h.say($code);

        .close for $input_h, $output_h;

        # XXX better invocation
        # XXX use $?COMPILER once we have it
        my $status = run('sh', '-c', "perl6 $input > $output");
        unless $status {
            die "perl6 $input died with status $status";
        }

        my $source     = TAP::Parser::Async::Source::File.new(filename => $output);
        my $tap-parser = $source.make-parser;

        await $tap-parser;
        $!tap-result = $tap-parser.result;
    }

    method ok {
        pass;
        self
    }

    method name($expected) {
        pass;
        self
    }
}

macro test($block) is export {
    my $code = $block.Str ~ '()';
    return quasi { Test::Meta.new(:$code) }
}

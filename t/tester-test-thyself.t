use v6;
use File::Temp;
use Test;

my @code = dir('t/data', test => /'.code' $/);

plan +@code;

for @code -> $code-file {
    my $results-file = IO::Path.new(
        :volume($code-file.volume),
        :directory($code-file.directory),
        :basename($code-file.basename.subst(/'.code' $/, '.result')),
    );

    my ( $output, $output_h ) = tempfile();
    $output_h.close;
    my $status = run('sh', '-c', "perl6 $code-file > $output");

    unless $status {
        die "bad exit status when running perl6 $code-file";
    }

    my $got      = slurp($output);
    my $expected = slurp($results-file);

    is $got, $expected;
}

package Text::WordDiff::Unified::ANSIColor;

# DATE
# VERSION

# based on MojoMojo::WordDiff, which in turn was based on Text::WordDiff

use strict;
use warnings;
use base qw(Exporter);
use Algorithm::Diff;

our @EXPORT = qw(word_diff);

our %colors = (
    delete_line => "\e[31m",
    insert_line => "\e[32m",
    delete_word => "\e[7m",
    insert_word => "\e[7m",
);

sub _split_str {
    split /\b/, $_[0];
}

sub word_diff {
    my @args = map {my @a = _split_str($_); \@a;} @_;
    my $diff = Algorithm::Diff->new(@args);
    my $out1 = $colors{delete_line} . "-";
    my $out2 = $colors{insert_line} . "+";
    while ($diff->Next) {
        if (my @same = $diff->Same) {
            $out1 .= (join '', @same);
            $out2 .= (join '', @same);
        } else {
            if (my @del = $diff->Items(1)) {
                $out1 .= $colors{delete_word} . (join '', @del) . "\e[0m" . $colors{delete_line};
            }
            if (my @ins = $diff->Items(2)) {
                $out2 .= $colors{insert_word} . (join '', @ins) . "\e[0m" . $colors{insert_line};
            }
        }
    }

    return $out1 . "\e[0m" . $out2 . "\e[0m";
}

# ABSTRACT: Generate unified-style word-base ANSIColor diffs

=head1 SYNOPSIS

 use Text::WordDiff::Unified::ANSIColor;

 say word_diff "line 1", "line 2";

Sample output (color shown using <I<color>> and <I</color>>):

 <red>-line <reverse>1</reverse></red>
 <green>+line <reverse>2</reverse></green>


=head1 DESCRIPTION


=head1 SEE ALSO

L<Text::WordDiff>

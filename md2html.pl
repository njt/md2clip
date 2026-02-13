#!/usr/bin/perl
# md2html.pl — Convert Markdown to styled HTML for clipboard pasting.
# Usage: perl md2html.pl input.md [output.html]
# If output is omitted, writes to stdout.

use strict;
use warnings;
use utf8;
use FindBin;
use lib "$FindBin::Bin/lib";

use Markdown::Perl;
use Encode qw(decode encode);

binmode(STDIN,  ':utf8');
binmode(STDOUT, ':utf8');
binmode(STDERR, ':utf8');

my $input_file  = $ARGV[0] or die "Usage: $0 input.md [output.html]\n";
my $output_file = $ARGV[1];

# Read input
open my $fh, '<:utf8', $input_file or die "Cannot open $input_file: $!\n";
my $md = do { local $/; <$fh> };
close $fh;

# Normalize CRLF to LF — Markdown::Perl's table parser chokes on \r before \n.
$md =~ s/\r\n/\n/g;

# Convert markdown to HTML
my $parser = Markdown::Perl->new;
my $html = $parser->convert($md);

# Add inline CSS styles for clipboard-friendly rich text.
# Clipboard HTML has no stylesheet support, so everything must be inline.
$html = add_inline_styles($html);

# Write output
if ($output_file) {
    open my $out, '>:utf8', $output_file or die "Cannot open $output_file: $!\n";
    print $out $html;
    close $out;
} else {
    print $html;
}

sub add_inline_styles {
    my ($h) = @_;

    # Code blocks: <pre><code> with background and monospace font.
    # Use placeholder to protect inner <code> from the inline-code regex.
    $h =~ s{<pre><code(?:\s+class="language-(\w+)")?>}
           {<pre style="background-color:#f4f4f4; padding:8px; border-radius:4px; font-family:Consolas,'Courier New',monospace; white-space:pre-wrap; font-size:13px; margin:8px 0; overflow-x:auto;"><xcode>}g;
    $h =~ s{</code></pre>}{</xcode></pre>}g;

    # Inline code (only standalone instances — pre>code is now <xcode>)
    $h =~ s{<code>([^<]*?)</code>}
           {<code style="background-color:#f0f0f0; padding:1px 4px; border-radius:3px; font-family:Consolas,'Courier New',monospace; font-size:13px;">$1</code>}g;

    # Restore <code> inside <pre>
    $h =~ s{<xcode>}{<code>}g;
    $h =~ s{</xcode>}{</code>}g;

    # Tables
    $h =~ s{<table>}
           {<table style="border-collapse:collapse; margin:8px 0;">}g;
    $h =~ s{<th>}
           {<th style="border:1px solid #ccc; padding:6px 10px; font-weight:bold; background-color:#f6f6f6; text-align:left;">}g;
    $h =~ s{<td>}
           {<td style="border:1px solid #ccc; padding:6px 10px;">}g;

    # Blockquotes
    $h =~ s{<blockquote>}
           {<blockquote style="border-left:3px solid #ccc; padding-left:12px; color:#555; margin:8px 0;">}g;

    # Headers
    $h =~ s{<h1>}{<h1 style="font-size:1.6em; margin:12px 0 6px 0; font-weight:bold;">}g;
    $h =~ s{<h2>}{<h2 style="font-size:1.3em; margin:10px 0 5px 0; font-weight:bold;">}g;
    $h =~ s{<h3>}{<h3 style="font-size:1.1em; margin:8px 0 4px 0; font-weight:bold;">}g;
    $h =~ s{<h4>}{<h4 style="font-size:1.0em; margin:6px 0 3px 0; font-weight:bold;">}g;

    # Paragraphs
    $h =~ s{<p>}{<p style="margin:6px 0;">}g;

    # Lists
    $h =~ s{<ul>}{<ul style="margin:4px 0; padding-left:24px;">}g;
    $h =~ s{<ol>}{<ol style="margin:4px 0; padding-left:24px;">}g;
    $h =~ s{<li>}{<li style="margin:2px 0;">}g;

    # Links
    $h =~ s{<a href="}{<a style="color:#0366d6; text-decoration:underline;" href="}g;

    return $h;
}

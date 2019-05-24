use strict;
use File::Temp qw/tempfile/;
use File::Basename;

my @Rscript = glob("example/*.R");
my $version = `Rscript -e "cat(installed.packages()['circlize', 'Version'])"`;

open HTML, ">index.html";

print HTML "
<html>
<head>
<title>Hello circlize</title>
<style>
img {
	width:300px;
}

#comment {
	border: 1px black solid;
	margin:10px 0px;
}
</style>

</head>
<body>
<h2>Examples of using <b>circlize</b> (version: $version)</h2>
<p>Click on the figures to view source code. If you have fancy figures generated by <i>circlize</i>, you can send me (z.gu<span style='border:1px solid black;border-radius:4px;-moz-border-radius: 4px;-webkit-border-radius: 4px;font-family: Century Gothic;padding: 0px 2px;font-size: 0.8em;'>a</span>dkfz.de) the figures and code and I will put them here.</p>
<table>";

my %not_run = {
	"doodle.pdf" => 1,
};

my $i = 1;
foreach my $R (sort { (stat($b))[9] <=> (stat($a))[9] } @Rscript) {
	print "running $R\n";

	my $pdf = $R;
	my $jpg = $R;
	my $jpg_small = $R;
	my $html = $R;
	$pdf =~s/R$/pdf/;
	$jpg =~s/R$/jpg/;
	$jpg_small =~s/R$/small.jpg/;
	$html =~s/R$/html/;

	if($i % 4 == 1) {
		print HTML "<tr>";
	}
	
	my $timestamp = time.int(rand(999999));
	print HTML "<td><a href='$html'><img src='$jpg_small?$timestamp'/></a></td>";

	open HTML2, ">$html";
	print HTML2 "<html>
<head><meta charset='UTF-8' />
<title>$R</title>
<link rel='stylesheet' href='styles/github.css'>
<script src='highlight.pack.js'></script>
<script>hljs.initHighlightingOnLoad();</script>
</head><body><p><img src='".basename($jpg)."' style='width:1000px;height:1000px'></p><p><a href='".basename($pdf)."'>download PDF</a></p>\n";
	open R, $R;
	my $comment = "";
	while(my $line = <R>) {

		if($line =~/^##/) {
			$line =~s/^##\s+//;
			$comment .= "$line ";
		}
	}
	print HTML2 "<p id='comment'>$comment</p>\n";
	
	print HTML2 "<p id='code'><pre><code>";
	open R, $R;
	while(my $line = <R>) {

		if($line =~/^##/) {
			next;
		}
		$line =~s/\t/    /g;
		print HTML2 $line;
	}
	print HTML2 "</code></pre></p>\n</body></html>";
	close HTML2;
	close R;

	if($i % 4 == 0) {
		print HTML "</tr>\n";
	}

	$i ++;

	if(-e $not_run{$pdf}) {
		next;
	}

	open R, $R;

	my ($fh, $filename) = tempfile();
	print $fh "library(methods);pdf('$pdf', width = 8, height = 8)\n";
	while(<R>) {
		print $fh $_;
	}
	print $fh "\ndev.off()\n";
	close($fh);

	system("Rscript $filename");
	unlink($filename);
	
	system("convert -density 200 $pdf $jpg");
	system("convert $jpg -scale 300x300 $jpg_small");
} 

if($i % 4 != 0) {
	print HTML "</tr>\n";
}

print HTML "</body></html>";


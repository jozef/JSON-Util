#!/usr/bin/perl

use strict;
use warnings;

use utf8;

#use Test::More 'no_plan';
use Test::More tests => 5;
use Test::Differences;
use File::Temp 'tempdir';
use IO::Any;

use FindBin '$Bin';

BEGIN {
	use_ok ( 'JSON::Util' ) or exit;
}

exit main();

sub main {
	my $jsonxs = JSON::XS->new->utf8->pretty->convert_blessed;
	my $tmpdir = tempdir( CLEANUP => 1 );
	
    eq_or_diff(
		JSON::Util->decode([$Bin, 'stock', '01.json']),
		{'bar' => 'foo'},
		'JSON::Util->decode("filename")'
	);
	
    JSON::Util->encode(
		[
			'foo'   => 'baz',
			'ščžť'  => 'ľřďôŮ',
			'トップ' => 'お問い合わせ'
		],
		[$tmpdir, 'someother.json'],
	);
	my $test_json_file_content = IO::Any->slurp([$tmpdir, 'someother.json']);
	$test_json_file_content =~ s/\s+$//; # strip final newline (introduced in JSON::XS 2.26)
    eq_or_diff(
		$test_json_file_content,
		IO::Any->slurp([$Bin, 'stock', '02.json']),
		'JSON::Util->encode()',
	);
	
	my $json = JSON::Util->new('pretty' => 0);
	is($json->encode([987,789]), '[987,789]', '$json->encode([])');
	is($json->encode({987 => 789}), '{"987":789}', '$json->encode({})');

	return 0;
}


use strict;
use warnings;
use Module::Build;

use 5.010;

my $builder = Module::Build->new(
    module_name         => 'JSON::Util',
    license             => 'perl',
    dist_author         => 'Jozef Kutej <jkutej@cpan.org>',
    dist_version_from   => 'lib/JSON/Util.pm',
    requires => {
        'Scalar::Util' => 0,
        'IO::Any'      => 0,
        'Carp'         => 0,
        'JSON::XS'     => 0,
    },
    build_requires => {
        'Test::More'        => 0,
        'Test::Differences' => 0,
        'File::Temp'        => 0,
        'Test::Exception'   => 0,
    },
    add_to_cleanup      => [ 'JSON-Util-*' ],
    create_makefile_pl => 'traditional',
    create_readme       => 1,
    sign                => 1,
);

$builder->create_build_script();

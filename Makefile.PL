use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'WebService::OCTranspo',
    AUTHOR              => q{Dave O'Neill <dmo@dmo.ca>},
    VERSION_FROM        => 'lib/WebService/OCTranspo.pm',
    ABSTRACT_FROM       => 'lib/WebService/OCTranspo.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'WebService-OCTranspo-*' },
);

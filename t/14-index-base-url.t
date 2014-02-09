use strict;
use warnings FATAL => 'all';

use Test::More;
use if $ENV{AUTHOR_TESTING}, 'Test::Warnings';
use Test::DZil;
use Test::Fatal;
use Test::Deep;
use File::Spec;
use Path::Tiny;
use Moose::Util 'find_meta';
use Dist::Zilla::App::Command::stale;

use lib 't/lib';
use NoNetworkHits;

BEGIN {
    use Dist::Zilla::Plugin::PromptIfStale;
    $Dist::Zilla::Plugin::PromptIfStale::VERSION = 9999
        unless $Dist::Zilla::Plugin::PromptIfStale::VERSION;
}

my @checked_via_02packages;
{
    my $meta = find_meta('Dist::Zilla::Plugin::PromptIfStale');
    $meta->make_mutable;
    $meta->add_around_method_modifier(_indexed_version_via_query => sub {
        my $orig = shift;
        my $self = shift;
        my ($module) = @_;
        die 'should not be checking for ' . $module;
    });
    $meta->add_around_method_modifier(_indexed_version_via_02packages => sub {
        my $orig = shift;
        my $self = shift;
        my ($module) = @_;

        $self->_get_packages;   # force this to be initialized in the class
        push(@checked_via_02packages, $module), return undef if $module =~ /^Unindexed[0-6]$/;
        die 'should not be checking for ' . $module;
    });
    my $packages;
}

# ensure we don't actually make network hits
my $http_url;
{
    use HTTP::Tiny;
    package HTTP::Tiny;
    no warnings 'redefine';
    sub mirror { $http_url = $_[1]; +{ success => 1 } }
}
{
    use Parse::CPAN::Packages::Fast;
    package Parse::CPAN::Packages::Fast;
    my $initialized;
    no warnings 'redefine';
    sub new {
        die if $initialized;
        'fake packages object ' . $initialized++;
    }
}

{
    my $tzil = Builder->from_config(
        { dist_root => 't/does-not-exist' },
        {
            add_files => {
                'source/dist.ini' => simple_ini(
                    [ GatherDir => ],
                    [ PromptIfStale => {
                        modules => [ map { 'Unindexed' . $_ } 0..5 ],
                        phase => 'build',
                        index_base_url => 'http://gettysworld.org',
                        fatal => 1,
                      } ],
                ),
                path(qw(source lib Foo.pm)) => "package Foo;\n1;\n",
            },
            also_copy => { 't/lib' => 't/lib' },
        },
    );

    {
        my $wd = File::pushd::pushd($tzil->root);
        cmp_deeply(
            [ Dist::Zilla::App::Command::stale->stale_modules($tzil) ],
            [ map { 'Unindexed' . $_ } 0..5 ],
            'app finds no stale modules',
        );
        Dist::Zilla::Plugin::PromptIfStale::__clear_already_checked();
    }

    $tzil->chrome->logger->set_debug(1);

    local @INC = @INC;
    unshift @INC, File::Spec->catdir($tzil->tempdir, qw(t lib));

    like(
        exception { $tzil->build },
        qr/\Q[PromptIfStale] Aborting build\E/,
        'build aborted',
    );

    cmp_deeply(
        \@checked_via_02packages,
        [ map { 'Unindexed' . $_ } 0..5 ],
        'all modules checked using 02packages',
    );

    like($http_url, qr{^http://gettysworld.org/}, 'overridden index URL used');

    cmp_deeply(
        $tzil->log_messages,
        superbagof("[PromptIfStale] Aborting build\n[PromptIfStale] To remedy, do: cpanm " . join(' ', map { 'Unindexed' . $_ } 0..5)),
        'build was aborted, with remedy instructions',
    ) or diag 'got: ', explain $tzil->log_messages;
}

done_testing;
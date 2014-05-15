use strict;
use warnings;

# this test was generated with Dist::Zilla::Plugin::Test::NoTabs 0.08

use Test::More 0.88;
use Test::NoTabs;

my @files = (
    'lib/Dist/Zilla/App/Command/stale.pm',
    'lib/Dist/Zilla/Plugin/EnsureNotStale.pm',
    'lib/Dist/Zilla/Plugin/PromptIfStale.pm',
    't/00-report-prereqs.t',
    't/01-basic.t',
    't/02-not-installed.t',
    't/03-bunk-module.t',
    't/04-two-configs.t',
    't/05-check-all-prereqs.t',
    't/06-duplicates.t',
    't/07-two-stale.t',
    't/08-many-modules.t',
    't/10-release-prompt.t',
    't/11-local-module.t',
    't/12-skip.t',
    't/13-fatal.t',
    't/14-index-base-url.t',
    't/15-command.t',
    't/16-command-all.t',
    't/17-command-missing-plugins.t',
    't/18-command-old-plugins.t',
    't/19-build-failure.t',
    't/20-ensure-not-stale.t',
    't/21-authordeps.t',
    't/lib/NoNetworkHits.pm',
    't/lib/Unindexed.pm',
    't/lib/Unindexed0.pm',
    't/lib/Unindexed1.pm',
    't/lib/Unindexed2.pm',
    't/lib/Unindexed3.pm',
    't/lib/Unindexed4.pm',
    't/lib/Unindexed5.pm',
    't/lib/Unindexed6.pm',
    'xt/author/00-compile.t',
    'xt/author/pod-spell.t',
    'xt/release/changes_has_content.t',
    'xt/release/clean-namespaces.t',
    'xt/release/cpan-changes.t',
    'xt/release/distmeta.t',
    'xt/release/eol.t',
    'xt/release/kwalitee.t',
    'xt/release/minimum-version.t',
    'xt/release/mojibake.t',
    'xt/release/no-tabs.t',
    'xt/release/pod-coverage.t',
    'xt/release/pod-no404s.t',
    'xt/release/pod-syntax.t',
    'xt/release/portability.t'
);

notabs_ok($_) foreach @files;
done_testing;

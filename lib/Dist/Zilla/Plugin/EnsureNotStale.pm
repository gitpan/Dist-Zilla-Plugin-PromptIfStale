use strict;
use warnings;
package Dist::Zilla::Plugin::EnsureNotStale;
# ABSTRACT: Abort at build/release time if modules are out of date
# vim: set ts=8 sw=4 tw=78 et :
$Dist::Zilla::Plugin::EnsureNotStale::VERSION = '0.028';
use Moose;
extends 'Dist::Zilla::Plugin::PromptIfStale';
use namespace::autoclean;

has '+fatal' => (
    init_arg => undef,  # cannot be passed in as a config value
    default => 1,
);

__PACKAGE__->meta->make_immutable;

__END__

=pod

=encoding UTF-8

=head1 NAME

Dist::Zilla::Plugin::EnsureNotStale - Abort at build/release time if modules are out of date

=head1 VERSION

version 0.028

=head1 SYNOPSIS

In your F<dist.ini>:

    [EnsureNotStale]

=head1 DESCRIPTION

This is a L<Dist::Zilla> plugin that behaves just like
L<[PromptIfStale]|Dist::Zilla::Plugin::PromptIfStale> would with its C<fatal>
option set to true. Therefore, if there are any stale modules found, the build
or release is aborted immediately.

=head1 CONFIGURATION OPTIONS

All options are as for L<[PromptIfStale]|Dist::Zilla::Plugin::PromptIfStale>,
except C<fatal> cannot be passed or set (it is always true).

=head1 SUPPORT

=for stopwords irc

Bugs may be submitted through L<the RT bug tracker|https://rt.cpan.org/Public/Dist/Display.html?Name=Dist-Zilla-Plugin-PromptIfStale>
(or L<bug-Dist-Zilla-Plugin-PromptIfStale@rt.cpan.org|mailto:bug-Dist-Zilla-Plugin-PromptIfStale@rt.cpan.org>).
I am also usually active on irc, as 'ether' at C<irc.perl.org>.

=head1 ACKNOWLEDGEMENTS

Getty made me do this!

=head1 SEE ALSO

=over 4

=item *

the L<[PromptIfStale]|Dist::Zilla::Plugin::PromptIfStale> plugin in this distribution

=item *

the L<dzil stale|Dist::Zilla::App::Command::stale> command in this distribution

=item *

L<Dist::Zilla::Plugin::Prereqs::MatchInstalled>, L<Dist::Zilla::Plugin::Prereqs::MatchInstalled::All>

=back

=head1 AUTHOR

Karen Etheridge <ether@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Karen Etheridge.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

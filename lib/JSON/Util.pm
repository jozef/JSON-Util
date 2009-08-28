package JSON::Util;

=head1 NAME

JSON::Util - encode/decode with artificial stupidity

=head1 SYNOPSIS

    use JSON::Util;
    $data = JSON::Util->decode('{"bar": "foo"}');
    $data = JSON::Util->decode('some.json');
    JSON::Util->encode({ 'foo' => 'bar' }, 'someother.json');

    $data = JSON::Util->decode(['..', 'folder', some.json]);
    JSON::Util->encode([123,321], ['..', 'folder', someother.json]);

    print JSON::Util->encode([987,789]), "\n";
    print JSON::Util->encode({987 => 789}), "\n";

    my $json = JSON::Util->new(pretty => 0, convert_blessed => 1);
    print $json->encode([ $object, $object2 ]);

=head1 DESCRIPTION

=cut

use warnings;
use strict;

our $VERSION = '0.01';

use 5.010;
use feature 'state';

use Scalar::Util 'blessed';
use IO::Any;
use Carp 'croak';
use JSON::XS;

=head1 METHODS

=head2 new()

Object constructor. Needed only when the L</default_json> configuration
needs to be changed. Any key/value passed as parameter will be called on
C<<JSON::XS->new()>> as C<<$json->$key($value)>>.

=cut

sub new {
    my $class = shift;
    my %options = (
        'utf8'            => 1,
        'pretty'          => 1,
        'convert_blessed' => 1,
        @_
    );

    my $self  = bless \%options, __PACKAGE__;
    
    my $json = JSON::XS->new();
    while (my ($option, $value) = each %options) {
        $json->$option($value);
    }

    $self->{'json'} = $json;
    
    return $self;
}

=head2 default_json

Returns C<<JSON::XS->new()>> with:

        'utf8'            => 1,
        'pretty'          => 1,
        'convert_blessed' => 1,

=cut

sub default_json {
    my $class = shift;
    state $json = $class->new->{'json'};
    return $json;
}

=head2 json

Returns current L<JSON::XS> object.

=cut

sub json {
    return (blessed $_[0] ? $_[0]->{'json'} : $_[0]->default_json);
}

=head2 decode($what)

Return ref with decoded C<$what>. For definition of C<$what> can be
please see L<IO::Any>.

=cut

sub decode {
    my $self = shift;
    my $what = shift;
    croak 'too many arguments'
        if @_;
    
    return $self->json->decode(IO::Any->slurp($what));
}

=head2 encode($data, [$where])

Returns encoded C<$data>. If C<$where> is passed then then the result is
written there. See L<IO::Any> for C<$where> options.

=cut

sub encode {
    my $self = shift;
    my $data = shift;
    
    # with one argument just do json encode
    return $self->json->encode($data)
        if (@_ == 0);
    
    my $where = shift;
    croak 'too many arguments'
        if @_;
    
    return IO::Any->spew($where, $self->json->encode($data));
}

1;


__END__

=head1 AUTHOR

Jozef Kutej, C<< <jkutej at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-json-util at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=JSON-Util>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc JSON::Util


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=JSON-Util>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/JSON-Util>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/JSON-Util>

=item * Search CPAN

L<http://search.cpan.org/dist/JSON-Util>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2009 Jozef Kutej, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

1; # End of JSON::Util

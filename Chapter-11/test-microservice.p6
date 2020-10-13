#!/usr/bin/env perl6

use Cro::HTTP::Test;
require "ingredients-microservice-v3.p6" <&static-routes>;

test-service static-routes, {
    test get('/'),
            status => 200,
            content-type => 'text/html',
            body => /recipes/;
}

done-testing;
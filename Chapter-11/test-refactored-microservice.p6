#!/usr/bin/env perl6

use Cro::HTTP::Test;
use My::Routes;

test-service static-routes, {
    test get('/'),
            status => 200,
            content-type => 'text/html',
            body => /recipes/;
    test get('/index.html'),
            status => 200,
            content-type => 'text/html',
            body => /"Recipes: index"/;
    test get("/foo"),
        status => 404;
}

test-service type-routes, {

        test get("Dessert"),
            status => 200,
            json => /Apple/;

    test get("foo"),
            status => 404;
}

test-service ingredient-routes, {
    test get("Apple"),
            status => 200,
            content-type => "application/json",
            body => *<Vegan> == True;
    test get("Olive%20Oil"),
            status => 200,
            content-type => "application/json",
            body => *<Vegan> == True;
    test get("Fishtails"),
        status => 404;
}

done-testing;
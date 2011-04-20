JS Test Driver Rails
====================

js-test-driver-rails is a thin wrapper for the JsTestDriver library: http://code.google.com/p/js-test-driver/

Configuration
------------

To take advantage of js-test-driver-rails, you should create a js_test_driver.rb file in your RAILS_ROOT/config/ directory.

The file may contain following directives:

    # the paths are relative to the current directory, but you can use absolute paths too
    # this is different from the JsTestDriver which does not allow you to use absolute paths in the config file 

    # files to be included
    includes 'foo', 'bar', 'public/javascripts/*.js'

    # files to be excluded, useful with globbing
    excludes 'public/javascripts/fail.js'

    # the host to which the test runner will connect, by default 'localhost'
    host 'my-laptop'

    # the port to which test runner will connect, and on which the test server will start, by default 4224
    port 6666

    # you can specify the default browsers which will be captured
    browser 'firefox'

Note, that this is a ruby file, so the file/browser list can be generated dynamically - it's completely up to you.

For example in our project we examine a list of known browsers to determine the ones installed on the developer's system, and define only those that were found.

Similarly we get the list of .js files to include from our asset packaging solution.

HTML Fixtures
-------------

js-test-driver-rails also allows you to define HTML fixtures easily.

Imagine you have a directory structure like this:

    RAILS_ROOT:
      test/
        js/
          fixtures/
            foo/
              a.html
            a.html

Then by defining the fixtures directory in your config file:

    fixtures "test/js/fixtures"

At runtime, your tests will have access to the contents of the fixture files:

    htmlFixtures.all["a"] // contents of the test/js/fixtures/a.html
    htmlFixtures.all["foo/a"] // contents of the test/js/fixtures/foo/a.html

You can customize the namespace and fixture container name:

    # the fixtures will be accessible through myApp.html["<fixture name goes here>"]
    fixtures "test/js/fixtures", :name => "html", :namespace => "myApp"

Using Jasmine
-------------

By default JsTestDriver comes with a pretty simple Test::Unit like testing framework.
However it supports a couple of other frameworks, including Jasmine (http://pivotal.github.com/jasmine/), which is an RSpec-like BDD framework.

If you want to user Jasmine, simply add:

    enable_jasmine

in your config file, somewhere before including your test files and you are golden:)

Rake tasks
----------

This gem comes with some rake tasks, which you should require in your Rake file:

    require "js_test_driver/tasks"

To start the js test driver server:

    rake js_test_driver:start_server

To capture the default (or specified) browsers

    rake js_test_driver:capture_browsers [BROWSERS=foo,bar,baz]

To run the tests (all or the specified ones)

    rake js_test_driver:run_tests [TESTS=TestCase[.testMethod]]

To run the server, capture the browsers and run tests all in one command

    rake js_test_driver:run [TESTS=TestCase[.testMethod]] [BROWSERS=foo,bar,baz] [OUTPUT_XML=1 | OUTPUT_PATH=/some/dir] [CAPTURE_CONSOLE=1]

This last task is mostly useful on CI, because it's much faster to run the server and capture the browsers once and then run the tests again and again in development mode.


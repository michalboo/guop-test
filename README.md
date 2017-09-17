# guop-test [![Build Status](https://travis-ci.org/michalboo/guop-test.svg?branch=master)](https://travis-ci.org/michalboo/guop-test)

Example RSpec tests for the Guardian OpenPlaform content endpoint

##### Dependencies:
 - ruby 2.0 or newer
 - [bundler](http://bundler.io/) (`gem install bundler` should do it)
 - an api key is required to access the Guardian API, get one here: http://open-platform.theguardian.com/access/

##### Running the tests:
 - clone the repo
 - `cd guop-test`
 - `bundle install`
 - `API_KEY={your_api_key_goes_here} rspec`

##### Verbose logging:
Pass a `VERBOSE` enviroment variable with the value `true` to the test command to log more information about the network request performed by HTTParty.

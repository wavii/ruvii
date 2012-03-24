# Ruvii

A collection of functions and patterns that we use on a daily basis; also serving as a style guide.

## Usage

Stick it in your Gemfile and require it.

## Developing

We manage nearly all of the dev concerns of ruvii via [guard](https://github.com/guard/guard).  Just
kick off `guard` in the background, and it will take charge of running the tests and reloading them
whenever anything changes.

### Code Coverage

For small focused features like this, code coverage is great!  You have two options to get at it:

* Run `rake` or `rake coverage` - it will run the full test suite and report on coverage

* Start guard in coverage mode via `COVERAGE=yes guard` and you will have partial coverage reports
  written with each test run.

## License

rails-dev-tweaks is MIT licensed by Wavii, Inc. http://wavii.com

See the accompanying file, `MIT-LICENSE`, for the full text.

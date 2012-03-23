# -*- encoding: utf-8 -*-
require File.expand_path("../lib/ruvii/version", __FILE__)

Gem::Specification.new do |gem|
  gem.name        =  "ruvii"
  gem.description =  "A collection of functions and patterns that we use on a daily basis; also serving as a style guide."
  gem.summary     =  "Wavii's Ruby utility library"
  gem.authors     = ["Wavii, Inc."]
  gem.email       = ["info@wavii.com"]
  gem.homepage    =  "http://wavii.com/"

  gem.version  = Ruvii::VERSION
  gem.platform = Gem::Platform::RUBY

  gem.files      = `git ls-files`.split("\n")
  gem.test_files = `git ls-files -- {spec}/*`.split("\n")

  gem.require_paths = ["lib"]

  # The crazy-complex support library.  We cherry-pick a few specific features from it.
  # MIT License - https://github.com/rails/rails/blob/master/activesupport/MIT-LICENSE
  gem.add_runtime_dependency "activesupport", ">= 3.0.0"
end

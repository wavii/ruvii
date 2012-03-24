guard "bundler" do
  watch("Gemfile")
  watch(/^.+\.gemspec/)
end

guard "spork" do
  watch("Gemfile")
  watch("Gemfile.lock")
  watch(".rspec")              { :rspec }
  watch("spec/spec_helper.rb") { :rspec }

  watch("lib/ruvii/dependencies.rb") { :rspec }
end

guard "rspec", version: 2, drb: true do
  watch(%r{^spec/.+_spec\.rb$})

  watch("lib/ruvii.rb") { "spec" }

  watch(%r{^lib/ruvii/core_ext/(.+)\.rb$}) { |m| "spec/core_ext/#{m[1]}" }
  watch(%r{^lib/ruvii/(.+)\.rb$})          { |m| "spec/#{m[1]}_spec.rb" }
end

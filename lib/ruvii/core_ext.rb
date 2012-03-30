# # Core Extensions

# That's right, you get it all!
Dir[File.expand_path("../core_ext/*.rb", __FILE__)].each do |path|
  require "ruvii/core_ext/#{File.basename(path, ".rb")}"
end

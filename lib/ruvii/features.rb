Dir[File.expand_path("../features/*.rb", __FILE__)].each do |path|
  require "ruvii/features/#{File.basename(path, ".rb")}"
end

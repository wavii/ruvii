SimpleCov.start do
  add_filter "/spec/"

  add_group "Core Extensions", "ruvii/core_ext"
  add_group "Features",        "ruvii/features"
end

require "rake"
require "rspec/core/rake_task"


desc "Run RSpec code examples"
task :api_spec, :tag do |_spec, task_args|
  opts = []
  Rake::Task[:rspec].invoke(opts)
end

task :default => :api_spec

RSpec::Core::RakeTask.new(:rspec, :opts) do |spec, task_opts|
  spec.fail_on_error = true
  spec.rspec_opts = task_opts[:opts]
end

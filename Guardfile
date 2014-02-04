rspec_opts = {
  cmd: 'bundle exec rspec'
}

guard :rspec, rspec_opts do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/third_rail\.rb$}) { |m| "spec/third_rail_spec.rb" }
end


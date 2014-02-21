rspec_opts = {
  cmd: 'bundle exec rspec'
}

guard :rspec, rspec_opts do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$}) { |m| "spec/#{m[1]}_spec.rb" }
end


namespace :rcov do

  RSpec::Core::RakeTask.new(:rspec) do |t|
    rm "coverage.data" if File.exist?("coverage.data")
    t.pattern = 'spec/**/*_spec.rb'
    t.rcov = true
    t.rcov_opts = %w{--exclude osx\/objc,Users\/,gems\/,spec\/,teamcity}
    t.verbose = true
  end

end

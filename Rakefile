# -*- ruby -*-

$TESTING_MINIUNIT = true

require 'rubygems'
require 'hoe'

Hoe.plugin :seattlerb

Hoe.spec 'minitest' do
  developer 'Ryan Davis', 'ryand-ruby@zenspider.com'

  self.rubyforge_name = "bfts"
  self.testlib = :minitest
end

def loc dir
  system "find #{dir} -name \\*.rb | xargs wc -l | tail -1"
end

desc "stupid line count"
task :dickwag do
  puts
  puts "miniunit"
  puts
  print " lib  loc"; loc "lib"
  print " test loc"; loc "test"
  print " totl loc"; loc "lib test"
  print " flog = "; system "flog -s lib"

  puts
  puts "test/unit"
  puts
  Dir.chdir File.expand_path("~/Work/svn/ruby/ruby_1_8") do
    print " lib  loc"; loc "lib/test"
    print " test loc"; loc "test/testunit"
    print " totl loc"; loc "lib/test test/testunit"
    print " flog = "; system "flog -s lib/test"
  end
  puts
end

desc 'generate your gemspec (for bundler, etc)'
# see: http://blog.behindlogic.com/2008/10/auto-generate-your-manifest-and-gemspec.html
task :cultivate do
  system "touch Manifest.txt; rake check_manifest | grep -v \"(in \" | patch"
  system "rake debug_gem | grep -v \"(in \" > `basename \\`pwd\\``.gemspec"
end

# vim: syntax=Ruby

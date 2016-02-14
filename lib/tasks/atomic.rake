require 'testings/atomic.rb'

namespace :atomic do
  desc "atomic test task"
  task :exec => :environment do
    p = Testing::Atomic.new('TEST001'.freeze)
    p.test
  end

  desc "atomic test task 2"
  task :pipelined => :environment do
    p = Testing::Atomic.new('TEST002'.freeze)
    p.test2
  end
end

require 'testings/atomic.rb'

namespace :atomic do
  desc "atomic test task"
  task :exec => :environment do
    p = Testing::Atmic.new('TEST001'.freeze)
    p.test
  end
end

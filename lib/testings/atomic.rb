module Testing
class Atmic

  def initialize(key_name)
    @key = key_name
    @redis_db = Redis.new( :host => "localhost", :port => 6379, :db => 2 )
    # Rails.application.config.session_store :redis_store, :servers => { :host => "localhost", :port => 6379, :namespace => "sessions" }
  end

  def test
    (1..100000).each do |i|
      do_something
    end
  end

  def do_something
    val = @redis_db.get(@key)
    val ||= 0
    val = val.to_i + 1
    p "val=#{val}"
    @redis_db.set(@key,val.to_s)
  end
end
end

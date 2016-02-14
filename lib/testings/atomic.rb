module Testing
class Atomic

  def initialize(key_name)
    @key = key_name
    @redis_db = Redis.new( :host => "localhost", :port => 6379, :db => 2 )
    # Rails.application.config.session_store :redis_store, :servers => { :host => "localhost", :port => 6379, :namespace => "sessions" }
  end

  def test
    (1..100000).each do |i|
      do_something(@redis_db,@key)
    end
  end

  def test2
    (1..100000).each do |i|
      @redis_db.watch(@key) do
        @redis_db.multi
        do_something(@redis_db,@key)
        @redis_db.exec
      end
    end
  end

  def do_something(r, k)
    val = r.get(k)
    val ||= 0
    val = val.to_i + 1
    p "val=#{val}"
    r.set(k,val.to_s)
  end
end
end

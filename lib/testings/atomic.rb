module Testing
  class Atomic

    def initialize(key_name)
      @key = key_name
      @redis_db = Redis.new( :host => "localhost", :port => 6379, :db => 2 )
    end

    def test
      (1..100000).each do |i|
        do_something(@redis_db,@key)
      end
    end

    def test2
      (1..100000).each do |i|
        @redis_db.watch(@key) do
          do_something_2(@redis_db,@key)
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

    def do_something_2(r,k)
      ### 何でロックするのか？をここで決定
      lck = Redis::Lock.new(k, timeout: 0.1)

      ### このサンプルは、確実にロックを獲得してインクリメントするまでは処理を戻さない
      begin
        begin
          lck.lock do
            #### ここから
            val = r.get(k)
            val ||= 0
            val = val.to_i + 1
            p "val=#{val}"
            r.set(k,val.to_s)
            ### ここまでの処理がatomicになるよ
          end
          return
        rescue Redis::Lock::LockTimeout => e
          p "ロックを獲得できず"
        end
      end while true
    end
  end
end

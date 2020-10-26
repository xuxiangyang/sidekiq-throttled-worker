module Sidekiq
  module ThrottledWorker
    module Concurrency
      class << self
        def limit?(worker_class, jid)
          # only allow one worker check limit
          concurrency = worker_class.get_sidekiq_options["concurrency"]
          ttl = (worker_class.get_sidekiq_options["concurrency_ttl"] || 900) # assume worker should finish run in 15 minutes, and worker can not run completely max for 15 minutes in extreme case
          check_limit_key = "sidekiq:throttled_worker:check_limit:#{worker_class}"
          now = Time.now.to_f
          Sidekiq.redis do |conn|
            return true unless conn.set(check_limit_key, 1, nx: true, ex: 60)
            conn.zremrangebyscore(concurrency_key(worker_class), "-inf", "(#{now}")
            return true if conn.zcard(concurrency_key(worker_class)) >= concurrency && conn.zscore(concurrency_key(worker_class), jid).nil?
            conn.zadd(concurrency_key(worker_class), (now + ttl).to_i, jid)
            conn.expire(concurrency_key(worker_class), (now + ttl).to_i)

            false
          end
        ensure
          Sidekiq.redis do |conn|
            conn.del(check_limit_key)
          end
        end

        def finalize!(worker_class, jid)
          Sidekiq.redis do |conn|
            conn.zrem(concurrency_key(worker_class), jid)
          end
        end

        private

        def concurrency_key(worker_class)
          "sidekiq:throttled_worker:concurrency:#{worker_class}"
        end
      end
    end
  end
end

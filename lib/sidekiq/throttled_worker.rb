require 'sidekiq/throttled_worker/version'

module Sidekiq
  module ThrottledWorker
    class Error < StandardError; end
    class << self
      def setup!
        Sidekiq.configure_server do |config|
          require 'sidekiq/throttled_worker/fetch'
          require 'sidekiq/throttled_worker/middleware'
          require 'sidekiq/throttled_worker/concurrency'

          Sidekiq.options[:fetch] = Sidekiq::ThrottledWorker::Fetch
          config.server_middleware do |chain|
            chain.add Sidekiq::ThrottledWorker::Middleware
          end
        end
      end

      def redis=(hash)
        @redis = if hash.is_a?(ConnectionPool)
                   hash
                 else
                   Sidekiq::RedisConnection.create(hash)
                 end
      end

      def redis
        @redis ||= Sidekiq::RedisConnection.create
      end
    end
  end
end

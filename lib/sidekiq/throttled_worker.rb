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
    end
  end
end

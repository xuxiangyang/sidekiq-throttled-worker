module Sidekiq
  module ThrottledWorker
    class Middleware
      def call(worker, msg, _queue)
        yield
      ensure
        Concurrency.finalize!(worker.class, msg['jid']) if worker.class.get_sidekiq_options["concurrency"]
      end
    end
  end
end

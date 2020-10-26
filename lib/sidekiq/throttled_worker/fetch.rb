module Sidekiq
  module ThrottledWorker
    class Fetch < Sidekiq::BasicFetch
      alias original_retrieve_work retrieve_work

      def retrieve_work
        work = original_retrieve_work
        return work if work.nil?

        job_hash = Sidekiq.load_json(work.job)
        worker_class = Object.const_get(job_hash['class'])
        return work if worker_class.get_sidekiq_options["concurrency"].nil?

        if Concurrency.limit?(worker_class, job_hash['jid'])
          sleep(rand * 0.1) # wait 100ms to reduce redis qps
          work.requeue
          nil
        else
          work
        end
      end
    end
  end
end

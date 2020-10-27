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
          job_hash["concurrency_limit_count"] ||= 0
          job_hash["concurrency_limit_count"] += 1
          sleep(rand * [(job_hash["concurrency_limit_count"] - 1) * 0.01, 0.1].min)
          Sidekiq.redis do |conn|
            conn.lpush("queue:#{work.queue_name}", Sidekiq.dump_json(job_hash)) # put in queue end to auto wait some time in busy sidekiq cluster
          end
          nil
        else
          work
        end
      end
    end
  end
end

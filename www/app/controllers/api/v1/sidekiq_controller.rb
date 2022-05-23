require 'sidekiq/api'
module Api::V1
  class SidekiqController < ApiController
    def index
        render json: Sidekiq::Queue.all
    end

    def read_queue(qname="default")
      render json: Sidekiq::Queue.new(qname)
    end

    def clear_queue
      render json: Sidekiq::Queue.new.clear
    end

    def kill_job(qname="default", job_id)
      queue = Sidekiq::Queue.new(qname)
      queue.each do |job|
      #  job.klass # => 'MyWorker'
      #  job.args # => [1, 2, 3]
        job.delete if job.jid == job_id
      end
      render status: 200
    end

    def kill_users_last_job(user_id)
      queue = Sidekiq::Queue.new(qname)
      job_id = current_user.job_ids.members.last
      queue.each do |job|
        #  job.klass # => 'MyWorker'
        #  job.args # => [1, 2, 3]
        job.delete if job.jid == job_id
      end
      render status: 200
    end



    def find_job(jid)
      Sidekiq::Queue.new.find_job(jid)
    end

    def job_stats
      stats = Sidekiq::Stats.new
      blob =  stats.inspect.to_s
      render json: blob
    end

  end
end


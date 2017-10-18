require_relative "dothing_job"

module Dothing
  class Agent
    attr_accessor :agent_id, :thread_id

    def initialize
      self.agent_id = Random.rand(2_147_483_647)
    end

    def start
      self.action_loop
    end

    def next_job
      next_job = DothingJob.where(:status => DothingJob::STATUS_QUEUED)
                           .where(:queue => :test)
                           .where("dothing_jobs.agent_id IS NULL").first

      if next_job
        next_job.update_attributes({ :status => DothingJob::STATUS_RUNNING, :agent_id => self.agent_id })
      end

      next_job
    end

    def action_loop
      while 1
        next_job = self.next_job

        if next_job
          begin
            next_job.action_name.constantize.perform
            next_job.update_attributes({ :status => DothingJob::STATUS_DONE })
          rescue Exception => e
            next_job.update_attributes({ :status => DothingJob::STATUS_FAILED, :message => e.message })
          end
        else
          sleep(5)
        end
      end
    end
  end
end

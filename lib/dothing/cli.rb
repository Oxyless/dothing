require_relative "agent_pool"
require_relative "dothing_job"

module Dothing
  class Cli
    def initialize

    end

    def run
      require File.expand_path("../rails_test/config/environment.rb")
      ::Rails.application.eager_load!

      ::Rails.application.config.after_initialize do
        DothingJob.run_migration

        1.times do
          DothingJob.create({ :status => DothingJob::STATUS_QUEUED, :queue => :test, :action_name => "JobTest", :action_params => "" })
        end

        agent_pool = Dothing::AgentPool.new()
        agent_pool.start_agents
      end
    end
  end
end

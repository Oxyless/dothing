require_relative "agent_pool"
require_relative "avalanche_job"

module Avalanche
  class Cli
    def initialize

    end

    def run
      require File.expand_path("../rails_test/config/environment.rb")
      ::Rails.application.eager_load!

      ::Rails.application.config.after_initialize do
        AvalancheJob.run_migration

        AvalancheJob.delete_all
        1000.times do
          AvalancheJob.create({ :status => AvalancheJob::STATUS_QUEUED, :queue => :test, :action_name => "JobTest", :action_params => "" })
        end

        agent_pool = Avalanche::AgentPool.new()
        agent_pool.start_agents
      end
    end
  end
end

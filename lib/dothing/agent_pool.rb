require_relative "thread_manager"
require_relative "agent"

module Dothing
  class AgentPool
    def initialize
      @thread_manager = Dothing::ThreadManager.new
      @agents = {}
    end

    def start_agents
      nb_agent = 1

      nb_agent.times do
        agent = Dothing::Agent.new

        thread_id = @thread_manager.start_thread do
          agent.start
        end

        agent.thread_id = thread_id

        @agents[agent.agent_id] = agent
      end

      @thread_manager.start_thread do
        self.action_loop
      end

      @thread_manager.join_all
    end

    def action_loop
      while 1
        puts "kill_loop"

        DothingJob.where(:status => DothingJob::STATUS_KILLME)
                 .where(:queue => :test)
                 .where(:"dothing_jobs.agent_id" => @agents.map(&:agent_id))
                 .each do |dothing_job|
          puts dothing_job.agent_id
          if @agents[dothing_job.agent_id]
            puts "kill"
            @thread_manager.exit_thread(@agents[dothing_job.agent_id].thread_id)
          end
        end

        sleep(5)
      end
    end
  end
end

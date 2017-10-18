require "active_record"

class AvalancheJob < ActiveRecord::Base
  attr_accessible :queue, :perform_at, :status, :action_name, :action_params, :agent_id, :message

  STATUS_QUEUED   = 0
  STATUS_RUNNING  = 1
  STATUS_DONE     = 2
  STATUS_FAILED   = 3
  STATUS_DEAD     = 4
  STATUS_KILLME   = 5
  STATUS_KILLED   = 6
  STATUS_TIMEOUT  = 7

  def self.run_migration
    unless ActiveRecord::Base.connection.tables.include? "avalanche_jobs"
      ActiveRecord::Migration.create_table :avalanche_jobs do |t|
        t.integer :agent_id
        t.integer :status
        t.string :queue
        t.string :action_name
        t.text :action_params
        t.text :message

        t.datetime :perform_at

        t.timestamps
      end

      ActiveRecord::Migration.add_index :avalanche_jobs, :queue
    end
  end
end

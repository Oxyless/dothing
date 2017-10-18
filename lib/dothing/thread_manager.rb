module Dothing
  class ThreadManager
    def initialize
      @threads = {}
      @last_thread_id = 0
    end

    def start_thread(&block)
      new_thread = Thread.new {
        yield
      }

      thread_id = @last_thread_id + 1
      @threads[thread_id] = new_thread
      @last_thread_id += 1

      thread_id
    end

    def join_all
      @threads.each do |thread_id, thread|
        thread.join
      end
    end

    def exit_thread(thread_id)
      if @threads[thread_id]
        @threads[thread_id].exit()
      end
    end
  end
end

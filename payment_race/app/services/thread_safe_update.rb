# Concurency safe updating ActiveRecord object
# 1. find or create object
# 2. look for thread with same object in it
#    2.1 if present, then add to thread queue
#    2.2 if not present, then create thread with queue, add object to it
#    2.3. loop unitl queue empty > update object
#    2.4. when queue nil, stop thread; close queue

class ThreadSafeUpdate
  class << self

    def call(obj, &block)
      obj_thread = get_obj_thread(obj)

      if obj_thread
        obj_thread[:queue] << obj
      else
        queue = Queue.new
        queue << obj
        new_obj_thread(queue, obj, &block)
      end
    end

    private

    def update_object(obj)
      ActiveRecord::Base.connection_pool.with_connection do
        yield(obj) if block_given?
        obj.save
      end
    end

    def new_obj_thread(queue, obj, &block)
      tr = Thread.new do
        Thread.current[:object] = obj
        Thread.current[:queue]   = queue

        until queue.empty?
          member_obj = queue.pop rescue nil
          update_object(obj, &block) if member_obj
        end

        queue.close
      end

      tr.join
    end

    def get_obj_thread(obj)
      tr_arr = Thread.list.select do |t|
        t.status == 'run' && t[:object] == obj
      end

      tr_arr.first
    end
  end
end
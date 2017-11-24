def make_concurrent_calls(object, method, args, &block)
  ActiveRecord::Base.connection.disconnect! # for pg specially

  processes = 2.times.map do |i|

    ForkBreak::Process.new do |breakpoints|
      # Add a breakpoint after invoking the method
      original_method = object.method(method)
      object.stub(method) do
        value = original_method.call(args, &block)
        breakpoints << method
        value
      end

      object.send(method, args, &block)
    end
  end

  processes.each{ |process| process.run_until(method).wait }
  processes.each{ |process| process.finish.wait }
  
  ActiveRecord::Base.establish_connection
end
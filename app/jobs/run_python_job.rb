class RunPythonJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # sleep 10
    print_a.delay.deliver
  end

  def print_a
    puts("ジョブが実行されたよ！＼(^o^)／").deliver    
  end
end

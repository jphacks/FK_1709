class RunPythonJob < ApplicationJob
  queue_as :default

  def perform(*args)
    sleep 10
    puts "ジョブが実行されたよ！＼(^o^)／"    
  end
end

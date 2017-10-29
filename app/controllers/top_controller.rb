class TopController < ApplicationController
  def index
    RunPythonJob.perform_now
  end
end

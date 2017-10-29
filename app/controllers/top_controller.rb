class TopController < ApplicationController
  def index
    Thread.start do
      a = `cd #{Rails.root}/python; python predict_with_svm.py ./test/itaya.txt` 
      p "aaa"
      p a 
    end
  end
end

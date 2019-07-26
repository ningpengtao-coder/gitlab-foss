# frozen_string_literal: true

class BackgroundCounterWorker
  include ApplicationWorker

  def perform(class_name)
    # todo: add lease
    class_name.constantize.new.recalculate!
  rescue NameError
    # ignore
  end
end

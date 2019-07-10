class JobWorker

  attr_reader :job

  def initialize(job)
    @job = job
  end

  def perform
    # Do nothing
  end
end

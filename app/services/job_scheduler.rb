class JobScheduler

  attr_reader :ident
  def initialize(ident = nil)
    @ident = ident
  end

  def start_work!
    while run_next_job
    end
  end

  private
  def run_next_job
    ActiveRecord::Base.transaction do
      job = dequeue_job!

      unless job
        Rails.logger.info "Nothing to do."
        return false
      end

      log = JobLog.new(job: job, scheduler: ident)

      # Note that we may want to trade full consistency over
      # making sure the database transactions are short.
      #
      # We could reschedule the job here and commit
      # and only then execute the job.

      begin
        JobWorker.new(job).perform
      ensure
        log.save!
        reschedule(job)
      end

      return true
    end
  end

  def dequeue_job!
    Job.lock('FOR UPDATE SKIP LOCKED').where('scheduled_for <= NOW()').order(:scheduled_for, :id).limit(1).first
  end

  def reschedule(job)
    job.scheduled_for = Time.now() + 10.seconds
    job.save!
  end
end

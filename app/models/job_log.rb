class JobLog < ApplicationRecord
  belongs_to :job

  after_initialize do |log|
    log.started_at = Time.now()
  end

  before_create do
    if self.finished_at.blank?
      self.finished_at = Time.now()
    end
  end
end

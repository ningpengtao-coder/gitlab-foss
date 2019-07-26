# frozen_string_literal: true

class BackgroundCounter < ApplicationRecord
  before_save :set_updated_at

  private

  def set_updated_at
    self.updated_at = Time.now
  end
end

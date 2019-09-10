# frozen_string_literal: true

# :nocov:
module DeliverNever
  def deliver_later
    self
  end
end

module MuteNotifications
  def new_note(note)
  end
end

module Gitlab
  class Seeder
    extend ActionView::Helpers::NumberHelper

    ESTIMATED_INSERT_PER_MINUTE = 2_000_000

    def self.with_mass_insert(size, model, strategy = :series)
      humanized_size = number_with_delimiter(size)
      humanized_model_name = model.model_name.human.pluralize(size)
      estimative = humanized_insert_time_message(size, strategy)

      puts "\nCreating #{humanized_size} #{humanized_model_name} (#{strategy} strategy)."
      puts estimative

      yield

      puts "\n#{number_with_delimiter(size)} #{humanized_model_name} created!"
    end

    def self.humanized_insert_time_message(size, strategy)
      estimated_minutes = (size.to_f / ESTIMATED_INSERT_PER_MINUTE).round
      estimated_minutes = estimated_minutes * 3 if strategy == :batch
      humanized_minutes = 'minute'.pluralize(estimated_minutes)

      if estimated_minutes.zero?
        "Estimated time: less than a minute ⏰"
      else
        "Estimated time: #{estimated_minutes} #{humanized_minutes} ⏰"
      end
    end

    def self.quiet
      # Disable database insertion logs so speed isn't limited by ability to print to console
      old_logger = ActiveRecord::Base.logger
      ActiveRecord::Base.logger = nil

      mute_notifications
      mute_mailer

      SeedFu.quiet = true

      yield

      SeedFu.quiet = false
      ActiveRecord::Base.logger = old_logger
      puts "\nOK".color(:green)
    end

    def self.without_gitaly_timeout
      # Remove Gitaly timeout
      old_timeout = Gitlab::CurrentSettings.current_application_settings.gitaly_timeout_default
      Gitlab::CurrentSettings.current_application_settings.update_columns(gitaly_timeout_default: 0)
      # Otherwise we still see the default value when running seed_fu
      ApplicationSetting.expire

      yield
    ensure
      Gitlab::CurrentSettings.current_application_settings.update_columns(gitaly_timeout_default: old_timeout)
      ApplicationSetting.expire
    end

    def self.mute_notifications
      NotificationService.prepend(MuteNotifications)
    end

    def self.mute_mailer
      ActionMailer::MessageDelivery.prepend(DeliverNever)
    end
  end
end
# :nocov:

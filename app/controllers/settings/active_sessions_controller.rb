# frozen_string_literal: true

class Settings::ActiveSessionsController < Settings::ApplicationController
  def index
    @sessions = ActiveSession.list(current_user).reject(&:is_impersonated)
  end
end

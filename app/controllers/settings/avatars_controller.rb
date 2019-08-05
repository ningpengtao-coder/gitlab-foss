# frozen_string_literal: true

class Settings::AvatarsController < Settings::ApplicationController
  def destroy
    @user = current_user

    Users::UpdateService.new(current_user, user: @user).execute { |user| user.remove_avatar! }

    redirect_to settings_path, status: :found
  end
end

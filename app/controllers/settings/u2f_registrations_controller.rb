# frozen_string_literal: true

class Settings::U2fRegistrationsController < Settings::ApplicationController
  def destroy
    u2f_registration = current_user.u2f_registrations.find(params[:id])
    u2f_registration.destroy
    redirect_to settings_two_factor_auth_path, status: 302, notice: _("Successfully deleted U2F device.")
  end
end

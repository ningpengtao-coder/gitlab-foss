# frozen_string_literal: true

module Projects
  module ErrorTracking
    class TrackingsController < Projects::ApplicationController
      include ProjectUnauthorized

      def index
        # Add some data
        render
      end
    end
  end
end

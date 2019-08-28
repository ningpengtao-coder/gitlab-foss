# frozen_string_literal: true

module Gitlab
  class DiskAccessJsonLogger < Gitlab::JsonLogger
    def self.file_name_noext
      'disk_access_json'
    end
  end
end

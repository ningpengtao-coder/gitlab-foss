# frozen_string_literal: true

require 'spec_helper'

describe Paas::Cluster, type: :model do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:api_url) }
  it { is_expected.to validate_presence_of(:token) }
end

# frozen_string_literal: true

require 'spec_helper'

describe Paas::Namespace, type: :model do
  it { is_expected.to belong_to(:cluster).class_name('Clusters::Cluster') }
  it { is_expected.to belong_to(:project) }

  it { is_expected.to validate_presence_of(:name) }
end

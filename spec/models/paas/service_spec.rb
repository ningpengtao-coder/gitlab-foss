# frozen_string_literal: true

require 'spec_helper'

describe Paas::Service, type: :model do
  it { is_expected.to belong_to(:namespace).class_name('Paas::Namespace') }

  it { is_expected.to delegate_method(:project).to(:namespace) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:image) }
end

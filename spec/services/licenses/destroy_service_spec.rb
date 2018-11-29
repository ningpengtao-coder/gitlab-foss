# frozen_string_literal: true
require 'spec_helper'

describe Licenses::DestroyService do
  set(:license) { create(:license) }

  def destroy(user)
    described_class.new(license, user).execute
  end

  it 'destroys a license' do
    destroy(create(:admin))

    expect(License.where(id: license[:id])).not_to exist
  end

  it 'raises an error if the user cannot delete the license' do
    expect { destroy(create(:user)) }.to raise_error Gitlab::Access::AccessDeniedError
  end
end

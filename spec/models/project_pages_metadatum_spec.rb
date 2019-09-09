# frozen_string_literal: true

require 'spec_helper'

describe ProjectPagesMetadatum do
  describe '.update_pages_deployed' do
    let(:project) { create(:project) }

    [true, false].each do |flag|
      it "creates new record and sets deployed to #{flag} if none exists yet" do
        project.project_pages_metadatum.destroy!

        described_class.update_pages_deployed(project, flag)

        expect(project.reload.project_pages_metadatum.deployed).to eq(flag)
      end

      it "updates the existing record and sets deployed to #{flag}" do
        project_pages_metadatum = project.project_pages_metadatum
        project_pages_metadatum.update!(deployed: !flag)

        expect { described_class.update_pages_deployed(project, flag) }.to change {
          project_pages_metadatum.reload.deployed
        }.from(!flag).to(flag)
      end
    end
  end
end

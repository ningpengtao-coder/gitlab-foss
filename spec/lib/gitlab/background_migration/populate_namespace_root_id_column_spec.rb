# frozen_string_literal: true

require 'rails_helper'

describe Gitlab::BackgroundMigration::PopulateNamespaceRootIdColumn, :migration, schema: 20190617181054 do
  let(:namespaces_table) { table(:namespaces) }

  def create_namespace_for(parent:, iid:)
    namespaces_table.create!(
      name: "#{parent.name}-group_#{iid}",
      path: "#{parent.name}-group_#{iid}",
      parent_id: parent.id
    )
  end

  describe '#perform' do
    let(:root_namespace_a) { namespaces_table.create!(name: 'root_a', path: 'root-a') }
    let(:root_namespace_b) { namespaces_table.create!(name: 'root_b', path: 'root-b') }

    before do
      (1..10).each do |subgroup_id|
        create_namespace_for(parent: root_namespace_a, iid: subgroup_id)
        create_namespace_for(parent: root_namespace_b, iid: subgroup_id)
      end
    end

    it 'updates the root id of root namespaces' do
      subject.perform(root_namespace_a.id, root_namespace_b.id)

      expect(root_namespace_a.reload.root_id).to eq(root_namespace_a.id)
      expect(root_namespace_b.reload.root_id).to eq(root_namespace_b.id)
    end

    it 'updates the root id of all namespaces' do
      subject.perform(root_namespace_a.id, root_namespace_b.id)

      namespace_a_children = namespaces_table.where(parent_id: root_namespace_a.id)
      namespace_b_children = namespaces_table.where(parent_id: root_namespace_b.id)

      namespace_a_children.each do |group|
        expect(group.root_id).to eq(root_namespace_a.id)
      end

      namespace_b_children.each do |group|
        expect(group.root_id).to eq(root_namespace_b.id)
      end
    end

    context 'when a subgroup has children' do
      let(:subgroup) do
        create_namespace_for(
          parent: root_namespace_a,
          iid: 50
        )
      end

      before do
        (1..10).each do |subgroup_id|
          create_namespace_for(parent: subgroup, iid: subgroup_id)
        end
      end

      it 'updates inner groups' do
        subject.perform(root_namespace_a.id, root_namespace_b.id)

        subgroup_children = namespaces_table.where(parent_id: subgroup.id)

        expect(subgroup.reload.root_id).to eq(root_namespace_a.id)

        subgroup_children.each do |group|
          expect(group.root_id).to eq(root_namespace_a.id)
        end
      end
    end
  end
end

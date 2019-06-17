# frozen_string_literal: true

module Gitlab
  module BackgroundMigration
    # This background migration updates records on namespaces table
    # according to the given namespace IDs range.
    #
    # A single update is issued for the given range.
    class PopulateNamespaceRootIdColumn
      def perform(from_id, to_id)
        root_namespaces = root_namespaces_between(from_id: from_id, to_id: to_id)
        return if root_namespaces.empty?

        namespaces_information = associate_children_with_root_namespaces(root_namespaces)
        sql_query = build_update_namespaces_sql(namespaces_information)

        execute(sql_query)
      end

      private

      def root_namespaces_between(from_id:, to_id:)
        Namespace
          .where('parent_id IS NULL')
          .where(id: from_id..to_id)
      end

      def associate_children_with_root_namespaces(root_namespaces)
        {}.tap do |namespaces_information|
          root_namespaces.each do |root_namespace|
            root_namespace.self_and_descendants.each do |namespace|
              namespaces_information[namespace.id] = root_namespace.id
            end
          end
        end
      end

      def build_update_namespaces_sql(namespaces_information)
        case_statements = build_case_statements(namespaces_information)
        namespace_ids = namespaces_information.keys

        update_sql_query(case_statements: case_statements, namespace_ids: namespace_ids)
      end

      def build_case_statements(namespaces)
        [].tap do |namespaces_information|
          namespaces.each do |child_namespace_id, root_namespace_id|
            statement = "WHEN #{child_namespace_id} THEN #{root_namespace_id}"
            namespaces_information << statement
          end
        end
      end

      def update_sql_query(case_statements:, namespace_ids:)
        <<~SQL
        UPDATE namespaces
          SET root_id = CASE id
          #{case_statements.join("\n")}
          END
        WHERE id IN (#{namespace_ids.join(",")})
        SQL
      end

      def execute(sql)
        connection.execute(sql)
      end

      def connection
        @connection ||= ActiveRecord::Base.connection
      end
    end
  end
end

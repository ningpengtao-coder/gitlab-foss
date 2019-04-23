# frozen_string_literal: true

class Gitlab::BackgroundMigration::UpdateIngressApplication
  class Project < ActiveRecord::Base
    self.table_name = 'projects'

    has_many :cluster_projects, class_name: 'ClustersProject'
    has_many :clusters, through: :cluster_projects, class_name: 'Cluster'
  end

  class Cluster < ActiveRecord::Base
    self.table_name = 'clusters'

    has_one :application_ingress, class_name: 'Ingress'
  end

  class ClustersProject < ActiveRecord::Base
    self.table_name = 'cluster_projects'

    belongs_to :cluster, class_name: 'Cluster'
    belongs_to :project, class_name: 'Project'
  end

  class Ingress < ActiveRecord::Base
    self.table_name = 'clusters_applications_ingress'
  end

  def perform(from, to)
    app_name = 'ingress'

    project_ingress(from, to).each do |project_id, app_id|
      app = Clusters::Applications::Ingress.find(app_id)
      app.make_scheduled!
      ClusterUpgradeAppWorker.perform_async(app_name, app_id)
    end
  end

  private

  def project_ingress(from, to, &block)
    Project
      .joins(clusters: :application_ingress)
      .where('clusters_applications_ingress.id IN (?)', from..to)
      .pluck('projects.id, clusters_applications_ingress.id')
  end
end

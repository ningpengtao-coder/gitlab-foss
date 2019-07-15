# frozen_string_literal: true

require 'spec_helper'

describe API::Internal::Pages do
  describe "GET /internal/pages" do
    let(:pages_shared_secret) { SecureRandom.random_bytes(Gitlab::Pages::SECRET_LENGTH) }

    before do
      allow(Gitlab::Pages).to receive(:secret).and_return(pages_shared_secret)
    end

    def query_host(host, headers = {})
      get api("/internal/pages"), headers: headers, params: { host: host }
    end

    context 'feature flag disabled' do
      before do
        stub_feature_flags(pages_internal_api: false)
      end

      it 'responds with 404 Not Found' do
        query_host('pages.gitlab.io')

        expect(response).to have_gitlab_http_status(404)
      end
    end

    context 'feature flag enabled' do
      context 'not authenticated' do
        it 'responds with 401 Unauthorized' do
          query_host('pages.gitlab.io')

          expect(response).to have_gitlab_http_status(401)
        end
      end

      context 'authenticated' do
        def query_host(host)
          jwt_token = JWT.encode({ 'iss' => 'gitlab-pages' }, Gitlab::Pages.secret, 'HS256')
          headers = { Gitlab::Pages::INTERNAL_API_REQUEST_HEADER => jwt_token }

          super(host, headers)
        end

        context 'not existing host' do
          it 'responds with 404 Not Found' do
            query_host('pages.gitlab.io')

            expect(response).to have_gitlab_http_status(404)
          end
        end

        context 'custom domain' do
          it 'responds with the correct domain configuration' do
            namespace = create(:namespace, name: 'gitlab-org')
            project = create(:project, namespace: namespace, name: 'gitlab-ce')
            pages_domain = create(:pages_domain, domain: 'pages.gitlab.io', project: project)

            query_host('pages.gitlab.io')

            expect(response).to have_gitlab_http_status(200)
            expect(response).to match_response_schema('internal/pages/virtual_domain')

            expect(json_response['certificate']).to eq(pages_domain.certificate)
            expect(json_response['key']).to eq(pages_domain.key)

            lookup_path = json_response['lookup_paths'][0]
            expect(lookup_path['prefix']).to eq('/')
            expect(lookup_path['source']['path']).to eq('gitlab-org/gitlab-ce/public/')
          end
        end

        context 'namespaced domain' do
          let(:group) { create(:group, name: 'mygroup') }

          def deploy_pages(project)
            generic_commit_status = create(:generic_commit_status, :success, stage: 'deploy', name: 'pages:deploy')
            generic_commit_status.update!(project: project)
          end

          before do
            allow(Settings.pages).to receive(:host).and_return('gitlab-pages.io')
            allow(Gitlab.config.pages).to receive(:url).and_return("http://gitlab-pages.io")
          end

          context 'regular project' do
            it 'responds with the correct domain configuration' do
              project = create(:project, group: group, name: 'myproject')
              deploy_pages(project)

              query_host('mygroup.gitlab-pages.io')

              expect(response).to have_gitlab_http_status(200)
              expect(response).to match_response_schema('internal/pages/virtual_domain')

              lookup_path = json_response['lookup_paths'][0]
              expect(lookup_path['prefix']).to eq('/myproject/')
              expect(lookup_path['source']['path']).to eq('mygroup/myproject/public/')
            end
          end

          context 'group root project' do
            it 'responds with the correct domain configuration' do
              project = create(:project, group: group, name: 'mygroup.gitlab-pages.io')
              deploy_pages(project)

              query_host('mygroup.gitlab-pages.io')

              expect(response).to have_gitlab_http_status(200)
              expect(response).to match_response_schema('internal/pages/virtual_domain')

              lookup_path = json_response['lookup_paths'][0]
              expect(lookup_path['prefix']).to eq('/')
              expect(lookup_path['source']['path']).to eq('mygroup/mygroup.gitlab-pages.io/public/')
            end
          end
        end
      end
    end
  end
end

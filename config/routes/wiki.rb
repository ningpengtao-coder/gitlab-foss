scope(controller: :wikis) do
  scope(path: 'wikis', as: :wikis) do
    get :git_access
    get :pages
    get '/', to: redirect('%{namespace_id}/%{project_id}/wikis/home')
  end

  scope(path: 'wikis/page', as: :wiki_page, format: false) do
    post '/', to: 'wikis#create'
  end

  scope(path: 'wikis/pages', as: :wiki_pages, format: false) do
    post '/', to: 'wikis#create'
  end

  scope(path: 'wikis/page/*id', as: :wiki, format: false) do
    get :edit
    get :history
    post :preview_markdown
    get '/', action: :show
    put '/', action: :update
    delete '/', action: :destroy
  end

  scope(path: 'wikis/dir/*id', as: :wiki_dir, format: false) do
    get '/', action: :show_dir
  end
end

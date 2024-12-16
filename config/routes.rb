Rails.application.routes.draw do
  # Rota raiz
  root to: "home#index"
  get "export_csv", to: "home#export_csv"

  # Rota para Donos
  resources :donos do
    collection do
      get "gerar_pdf"
      get "gerar_csv"
    end
  end

  # Rota para Animais
  resources :animais do
    collection do
      get "gerar_pdf"
      get "gerar_csv"
    end
  end


  # Rota para Funcionarios
  resources :funcionarios do
    collection do
      get "gerar_pdf"
      get "gerar_csv"
    end
  end


  # Rota para Atendimentos
  resources :atendimentos do
    collection do
      get "gerar_pdf"
      get "gerar_csv"
      get "gerar_nota_fiscal"
    end
  end


  # Rota para Serviços
  resources :servicos do
    collection do
      get "gerar_pdf"
      get "gerar_csv"
    end
  end

  # Rota para Documentos
  resources :documentos

  # Outras rotas
  get "home/index"
  devise_for :users

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # PWA routes
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end

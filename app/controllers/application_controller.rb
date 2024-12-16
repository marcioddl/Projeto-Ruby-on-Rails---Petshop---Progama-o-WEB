
class ApplicationController < ActionController::Base
  # Garante que o usuário esteja logado antes de acessar qualquer recurso
  before_action :authenticate_user!

  # Permite apenas navegadores modernos com suporte a recursos específicos
  allow_browser versions: :modern
end


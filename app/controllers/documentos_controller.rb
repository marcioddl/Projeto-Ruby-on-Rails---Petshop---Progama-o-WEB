
  class DocumentosController < ApplicationController
  before_action :set_documento, only: %i[show edit update destroy]

  def index
    @documentos = Documento.all
  end

  def show
  end

  def new
    @documento = Documento.new
  end

  def create
    @documento = Documento.new(documento_params)

    if @documento.save
      redirect_to documentos_path, notice: "Documento enviado com sucesso!"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @documento.update(documento_params)
      redirect_to documentos_path, notice: "Documento atualizado com sucesso!"
    else
      render :edit
    end
  end

  def destroy
    @documento.destroy
    redirect_to documentos_path, notice: "Documento excluído com sucesso!"
  end

  private

  def set_documento
    @documento = Documento.find(params[:id])
  end

  def documento_params
    params.require(:documento).permit(:nome, :descricao, :arquivo)
  end
end



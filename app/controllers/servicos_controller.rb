class ServicosController < ApplicationController
  before_action :set_servico, only: [ :edit, :update, :destroy ]

  def index
    if params[:search].present?
      @servicos = Servico.where("nome LIKE ?", "#{params[:search]}%").page(params[:page]).per(5)
    else
      @servicos = Servico.page(params[:page]).per(5)
    end
  end

  def new
    @servico = Servico.new
  end

  def show
  end

  def edit
  end

  def update
    if @servico.update(servico_params)
      redirect_to servicos_path, notice: "Serviço atualizado com sucesso!"
    else
      render :edit
    end
  end

  def create
    @servico = Servico.new(servico_params)
    if @servico.save
      redirect_to servicos_path, notice: "Serviço criado com sucesso!"
    else
      render :new
    end
  end

  def destroy
    @servico.destroy
    redirect_to servicos_path, notice: "Serviço excluído com sucesso!"
  end



def gerar_pdf
  @servicos = Servico.all

  pdf = Prawn::Document.new
  pdf.text "Lista de Serviços", size: 20, style: :bold
  pdf.move_down 20

  @servicos.each do |servico|

    preco_formatado = sprintf("$%.2f", servico.preco)

    pdf.text "ID: #{servico.id}"
    pdf.text "Nome do Serviço: #{servico.nome}"
    pdf.text "Descrição: #{servico.descricao}"
    pdf.text "Preço: #{preco_formatado}" 
    pdf.move_down 10
  end

  send_data pdf.render, filename: "servicos.pdf", type: "application/pdf", disposition: "inline"
end



def gerar_csv
  @servicos = Servico.all

  bom = "\uFEFF"
  csv_data = CSV.generate(col_sep: ";", headers: true) do |csv|
    csv << [ "ID", "Nome do Serviço", "Descrição", "Preço" ]

    @servicos.each do |servico|
      preco_formatado = sprintf("$%.2f", servico.preco)

      csv << [ servico.id, servico.nome, servico.descricao, preco_formatado ]  
    end
  end

  send_data bom + csv_data, filename: "servicos.csv", type: "text/csv"
end
  private

  def set_servico
    @servico = Servico.find(params[:id])
  end

  def servico_params
    params.require(:servico).permit(:nome, :descricao, :preco)
  end
end

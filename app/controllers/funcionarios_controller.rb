class FuncionariosController < ApplicationController
  before_action :set_funcionario, only: [:show, :edit, :update, :destroy]

  def index
    if params[:search].present?
      @funcionarios = Funcionario.where("nome LIKE ?", "#{params[:search]}%").page(params[:page]).per(5)
    else
      @funcionarios = Funcionario.page(params[:page]).per(5)
    end
  end

  def new
    @funcionario = Funcionario.new
  end

  def show
  end

  def create
    @funcionario = Funcionario.new(funcionario_params)
    if @funcionario.save
      redirect_to funcionarios_path, notice: "Funcionário criado com sucesso!"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @funcionario.update(funcionario_params)
      redirect_to funcionarios_path, notice: "Funcionário atualizado com sucesso!"
    else
      render :edit
    end
  end

  def destroy
    @funcionario.destroy
    redirect_to funcionarios_path, notice: "Funcionário excluído com sucesso!"
  end

  def gerar_pdf
    @funcionarios = Funcionario.all

    pdf = Prawn::Document.new
    pdf.text "Lista de Funcionários", size: 20, style: :bold
    pdf.move_down 20

    @funcionarios.each do |funcionario|
      telefone_formatado = funcionario.telefone.gsub(/\D/, "").insert(0, "(").insert(3, ") ").insert(9, "-") if funcionario.telefone.present?

      pdf.text "ID: #{funcionario.id}"
      pdf.text "Nome: #{funcionario.nome}"
      pdf.text "Função: #{funcionario.funcao}" 
      pdf.text "Telefone: #{telefone_formatado}" 
      pdf.text "Registro: #{funcionario.registro}" 
      pdf.move_down 10
    end

    send_data pdf.render, filename: "funcionarios.pdf", type: "application/pdf", disposition: "inline"
  end

  def gerar_csv
    @funcionarios = Funcionario.all

    bom = "\uFEFF"

    csv_data = CSV.generate(col_sep: ";", headers: true) do |csv|
      csv << ["ID", "Nome", "Função", "Telefone", "Registro"]  

      @funcionarios.each do |funcionario|
        telefone_formatado = funcionario.telefone.gsub(/\D/, "").insert(0, "(").insert(3, ") ").insert(9, "-") if funcionario.telefone.present?

        csv << [funcionario.id, funcionario.nome, funcionario.funcao, telefone_formatado, funcionario.registro] 
      end
    end

    send_data bom + csv_data, filename: "funcionarios.csv", type: "text/csv"
  end

  private

  # Método que encontra o funcionário por ID
  def set_funcionario
    @funcionario = Funcionario.find_by(id: params[:id])

    # Caso o funcionário não seja encontrado, redireciona para a lista de funcionários com um aviso
    unless @funcionario
      redirect_to funcionarios_path, alert: "Funcionário não encontrado."
    end
  end

  # Método para garantir que apenas os parâmetros permitidos sejam usados
  def funcionario_params
    params.require(:funcionario).permit(:nome, :funcao, :telefone, :registro)
  end
end

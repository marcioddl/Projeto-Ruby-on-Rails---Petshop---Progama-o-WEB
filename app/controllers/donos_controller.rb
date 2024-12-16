class DonosController < ApplicationController
  before_action :set_dono, only: [ :edit, :update, :destroy ]

  def index
    if params[:search].present?
      # Filtra os donos cujos nomes começam com a letra fornecida
      @donos = Dono.where("nome LIKE ?", "#{params[:search].capitalize}%").page(params[:page]).per(5)
    else
      @donos = Dono.page(params[:page]).per(5)  # Retorna todos os donos quando não há busca
    end
  end

  def new
    @dono = Dono.new 
  end

  
  def create
    @dono = Dono.new(dono_params)
    if @dono.save
      redirect_to donos_path, notice: "Dono criado com sucesso."
    else
      render :new, alert: "Erro ao salvar o dono. Verifique os dados."
    end
  end


  def edit
 
  end

 
  def update
    if @dono.update(dono_params)
      redirect_to donos_path, notice: "Dono atualizado com sucesso."
    else
      render :edit
    end
  end


  def destroy
    @dono = Dono.find(params[:id])
    # Exclui todos os animais associados ao dono
    @dono.animals.destroy_all
    @dono.destroy
    redirect_to donos_path, notice: "Dono e seus animais excluídos com sucesso."
  end



  def gerar_pdf
    @donos = Dono.all

    pdf = Prawn::Document.new
    pdf.text "Lista de Donos", size: 20, style: :bold
    pdf.move_down 20

    @donos.each do |dono|
      telefone_formatado = dono.telefone.gsub(/\D/, "").insert(0, "(").insert(3, ") ").insert(9, "-") if dono.telefone.present?

      cpf_formatado = dono.cpf.gsub(/(\d{3})(\d{3})(\d{3})(\d{2})/, '\1.\2.\3-\4') if dono.cpf.present?

      pdf.text "ID: #{dono.id}"
      pdf.text "Nome: #{dono.nome}"
      pdf.text "Telefone: #{telefone_formatado}"
      pdf.text "Email: #{dono.email}"
      pdf.text "Endereço: #{dono.endereco}"
      pdf.text "CPF: #{cpf_formatado}"
      pdf.move_down 10
    end

    send_data pdf.render, filename: "donos.pdf", type: "application/pdf", disposition: "inline"
  end


  def gerar_csv
    @donos = Dono.all

    bom = "\uFEFF"

    csv_data = CSV.generate(col_sep: ";", headers: true) do |csv|
      csv << [ "ID", "Nome", "Telefone", "Email", "Endereço", "CPF" ] 

      @donos.each do |dono|
        telefone_formatado = dono.telefone.gsub(/\D/, "").insert(0, "(").insert(3, ") ").insert(9, "-") if dono.telefone.present?

        cpf_formatado = dono.cpf.gsub(/(\d{3})(\d{3})(\d{3})(\d{2})/, '\1.\2.\3-\4') if dono.cpf.present?

        csv << [ dono.id, dono.nome, telefone_formatado, dono.email, dono.endereco, cpf_formatado ] 
      end
    end

    send_data bom + csv_data, filename: "donos.csv", type: "text/csv"
  end

  private

 
  def dono_params
    params.require(:dono).permit(:nome, :telefone, :email, :endereco, :cpf)
  end

  def set_dono
    @dono = Dono.find(params[:id])
  end
end

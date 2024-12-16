class AtendimentosController < ApplicationController
  
  
  def index
    if params[:search].present?
      # Buscando atendimentos pelo nome do animal
      @atendimentos = Atendimento.joins(:animal).where("animais.nome LIKE ?", "#{params[:search]}%").page(params[:page]).per(5)
    else
      @atendimentos = Atendimento.page(params[:page]).per(5)
    end
    @atendimentos ||= []
  end

  def new
    @atendimento = Atendimento.new
    @servico = Servico.find(params[:servico_id]) if params[:servico_id].present?

    if @servico.present?
      @funcionarios = @servico.funcionarios 
    else
      @funcionarios = Funcionario.all 
    end
  end


  def create
    @atendimento = Atendimento.new(atendimento_params)
    if @atendimento.save
      redirect_to atendimentos_path, notice: "Atendimento criado com sucesso."
    else
      render :new
    end
  end


  def show
    @atendimento = Atendimento.find(params[:id])
  end



  def gerar_pdf
    @atendimentos = Atendimento.all

    pdf = Prawn::Document.new
    pdf.text "Lista de Atendimentos", size: 20, style: :bold
    pdf.move_down 20

    @atendimentos.each do |atendimento|
      pdf.text "Atendimento ID: #{atendimento.id}"
      pdf.text "Data: #{atendimento.data}"
      pdf.text "Animal: #{atendimento.animal.nome}"
      pdf.text "Funcionário: #{atendimento.funcionario.nome}"
      pdf.text "Descrição: #{atendimento.descricao}"
      pdf.move_down 10
    end

    send_data pdf.render, filename: "atendimentos.pdf", type: "application/pdf", disposition: "inline"
  end

  
  
  def gerar_csv
    @atendimentos = Atendimento.all

    bom = "\uFEFF"

    csv_data = CSV.generate(col_sep: ";", headers: true) do |csv|
      csv << [ "ID", "Data", "Animal", "Funcionário", "Descrição" ]

      @atendimentos.each do |atendimento|
        csv << [ atendimento.id, atendimento.data, atendimento.animal.nome, atendimento.funcionario.nome, atendimento.descricao ]
      end
    end

    send_data bom + csv_data, filename: "atendimentos.csv", type: "text/csv"
  end

  def edit
    @atendimento = Atendimento.find(params[:id])
  end

  def update
    @atendimento = Atendimento.find(params[:id])
    if @atendimento.update(atendimento_params)
      redirect_to atendimentos_path, notice: "Atendimento atualizado com sucesso!"
    else
      render :edit
    end
  end

  def destroy
    @atendimento = Atendimento.find(params[:id])
    if @atendimento.destroy
      redirect_to atendimentos_path, notice: "Atendimento excluído com sucesso!"
    else
      redirect_to atendimentos_path, alert: "Erro ao tentar excluir o atendimento."
    end
  end


    def gerar_nota_fiscal
      if params[:search].present?
        # Buscar o nome exato do animal
        @animais = Animal.where(nome: params[:search])

        # Verifica se algum animal foi encontrado
        if @animais.empty?
          redirect_to atendimentos_path, alert: "Nenhum animal encontrado com o nome '#{params[:search]}'."
          return
        end

        # Inicializa a variável para armazenar o valor total
        @total_custo = 0

        # Para cada animal com o nome filtrado, somamos o valor dos serviços realizados
        @animais.each do |animal|
          # Buscar os atendimentos desse animal
          atendimentos = Atendimento.where(animal_id: animal.id)

          # Somar o preço dos serviços associados a cada atendimento
          atendimentos.each do |atendimento|
            servico = Servico.find(atendimento.servico_id)
            @total_custo += servico.preco if servico.preco.present?
          end
        end

        # Geração do PDF
        pdf = Prawn::Document.new
        pdf.text "Nota Fiscal", size: 20, style: :bold
        pdf.move_down 20
        pdf.text "Nome do Animal: #{params[:search]}"
        pdf.move_down 10

        # Exibe a lista de serviços e preços
        pdf.text "Serviços Realizados:", size: 14, style: :bold
        pdf.move_down 10

        @animais.each do |animal|
          atendimentos = Atendimento.where(animal_id: animal.id)

          atendimentos.each do |atendimento|
            servico = Servico.find(atendimento.servico_id)
            pdf.text "#{servico.nome}: R$ #{servico.preco}", size: 12
          end
        end

        pdf.move_down 20
        pdf.text "Valor Total dos Serviços: R$ #{@total_custo}", size: 16, style: :bold

        # Envia o PDF gerado
        send_data pdf.render, filename: "nota_fiscal_#{Time.now.to_i}.pdf", type: "application/pdf", disposition: "inline"
      else
        redirect_to atendimentos_path, alert: "Por favor, forneça um nome de animal para gerar a nota fiscal."
      end
    end





  private

  def atendimento_params
    params.require(:atendimento).permit(:descricao, :animal_id, :funcionario_id, :servico_id)
  end
end

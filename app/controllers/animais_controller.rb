require "csv"

class AnimaisController < ApplicationController
  before_action :set_animal, only: %i[edit update destroy] # chamar o set para fazer as açoes 

  def index #exibir animal
    if params[:search].present? # se passar uma busca, retorna os aniamis com as letras indicadas
      @animais = Animal.where("nome LIKE ?", "#{params[:search]}%").page(params[:page]).per(5)
    else
      @animais = Animal.page(params[:page]).per(5)#kaminari 
    end
  end

  def new #isntancia animal vazio
    @animal = Animal.new
  end

  def create # receber os dados passados pela view 'new'
    @animal = Animal.new(animal_params)
    if @animal.save
      redirect_to animais_path, notice: "Animal criado com sucesso!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit #careegar os dados para serem editados e exibe o formulario
    
  end

  def update #atualiza os dados usando os dados fornecidos pela view "edit"
    if @animal.update(animal_params)
      redirect_to animais_path, notice: "Animal atualizado com sucesso!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy #apagar animal
    if @animal.destroy
      redirect_to animais_path, notice: "Animal excluído com sucesso."
    else
      redirect_to animais_path, alert: "Erro ao excluir o animal."
    end
  end

  def gerar_pdf
    @animais = Animal.all

    pdf = Prawn::Document.new
    pdf.text "Lista de Animais", size: 20, style: :bold
    pdf.move_down 20

    @animais.each do |animal|
      pdf.text "ID: #{animal.id}"
      pdf.text "Nome: #{animal.nome}"
      pdf.text "Espécie: #{animal.especie}"
      pdf.text "Raça: #{animal.raca}"
      pdf.text "Idade: #{animal.idade}"
      pdf.text "Dono: #{animal.dono.nome}"

      if animal.foto.present? && File.exist?(animal.foto.path)#carrega a fto se existir se nao colcoa vazio
        pdf.image animal.foto.path, fit: [ 100, 100 ]
      end

      pdf.move_down 20
    end

    send_data pdf.render, filename: "animais.pdf", type: "application/pdf", disposition: "inline"
  end



  def gerar_csv
    @animais = Animal.all

    bom = "\uFEFF" 

    csv_data = CSV.generate(col_sep: ";", headers: true) do |csv|
      csv << [ "ID", "Nome", "Espécie", "Raça", "Idade", "Dono" ]

      @animais.each do |animal|
        csv << [ animal.id, animal.nome, animal.especie, animal.raca, animal.idade, animal.dono.nome ]
      end
    end

    send_data bom + csv_data, filename: "animais.csv", type: "text/csv"
  end

  private

  def set_animal #localzia o animal pelo id
    @animal = Animal.find_by(id: params[:id])
    if @animal.nil?
      redirect_to animais_path, alert: "Animal não encontrado."
    end
  end

  def animal_params #paramentros que ppodem ser mandados para o banco
    params.require(:animal).permit(:nome, :especie, :raca, :idade, :dono_id, :foto) 
  end
end

class HomeController < ApplicationController
  def index

  end

  def export_csv
    # Define o caminho do arquivo
    file_path = Rails.root.join("public", "dados_completos.csv")

    # Abre o arquivo para escrita com codificação UTF-8 e adiciona BOM para Excel
    CSV.open(file_path, "wb", encoding: "UTF-8") do |csv|
      # Adiciona BOM para garantir que o Excel leia corretamente os caracteres especiais
      csv << [ "\uFEFFAnimal ID", "Nome", "Idade", "Espécie", "Raça", "Dono" ]

      # Exporta os dados da tabela 'animais'
      Animal.all.each do |animal|
        csv << [
          animal.id,
          animal.nome.encode('UTF-8', invalid: :replace, undef: :replace, replace: '?'),
          animal.idade,
          animal.especie.encode('UTF-8', invalid: :replace, undef: :replace, replace: '?'),
          animal.raca.encode('UTF-8', invalid: :replace, undef: :replace, replace: '?'),
          animal.dono.nome.encode('UTF-8', invalid: :replace, undef: :replace, replace: '?')
        ]
      end

      # Linha em branco para separar a próxima tabela
      csv << []

      # Exporta os dados da tabela 'atendimentos'
      csv << [ "Atendimento ID", "Data", "Serviço/Produtos", "Funcionario ID", "Servico ID", "Descrição" ]
      Atendimento.all.each do |atendimento|
        csv << [
          atendimento.id,
          atendimento.data,
          atendimento.servico.nome.encode('UTF-8', invalid: :replace, undef: :replace, replace: '?'),
          atendimento.funcionario.nome.encode('UTF-8', invalid: :replace, undef: :replace, replace: '?'),
          atendimento.servico.id,
          atendimento.descricao.encode('UTF-8', invalid: :replace, undef: :replace, replace: '?')
        ]
      end

      # Linha em branco para separar a próxima tabela
      csv << []

      # Exporta os dados da tabela 'donos'
      csv << [ "Dono ID", "Nome", "Telefone", "Endereço", "Email" ]
      Dono.all.each do |dono|
        csv << [
          dono.id,
          dono.nome.encode('UTF-8', invalid: :replace, undef: :replace, replace: '?'),
          dono.telefone,
          dono.endereco.encode('UTF-8', invalid: :replace, undef: :replace, replace: '?'),
          dono.email.encode('UTF-8', invalid: :replace, undef: :replace, replace: '?')
        ]
      end

      # Linha em branco para separar a próxima tabela
      csv << []

      # Exporta os dados da tabela 'funcionarios'
      csv << [ "Funcionario ID", "Nome", "Função", "Telefone", "Registro" ]
      Funcionario.all.each do |funcionario|
        csv << [
          funcionario.id,
          funcionario.nome.encode('UTF-8', invalid: :replace, undef: :replace, replace: '?'),
          funcionario.funcao.encode('UTF-8', invalid: :replace, undef: :replace, replace: '?'),
          funcionario.telefone,
          funcionario.registro
        ]
      end

      # Linha em branco para separar a próxima tabela
      csv << []

      # Exporta os dados da tabela 'servicos'
      csv << [ "Servico ID", "Nome", "Preço", "Descrição" ]
      Servico.all.each do |servico|
        csv << [
          servico.id,
          servico.nome.encode('UTF-8', invalid: :replace, undef: :replace, replace: '?'),
          servico.preco,
          servico.descricao.encode('UTF-8', invalid: :replace, undef: :replace, replace: '?')
        ]
      end
    end

    # Faz o download do arquivo gerado
    send_file file_path, filename: "dados_completos.csv", type: "text/csv", disposition: "attachment"
  end
end
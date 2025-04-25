defmodule Discordbot do

  use Nostrum.Consumer
  #`Nostrum.Consumer` - permite ao bot ouvir eventos do Discord.

  #atalhos
  alias Apis.Yn
  alias Apis.Conselho
  alias Apis.Piadas
  alias Apis.Numeros
  alias Apis.Pais
  alias Apis.Origemnome
  alias Apis.Ghibli
  alias Apis.Gatos
  alias Nostrum.Api

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do

    cond do

      String.starts_with?(msg.content, "!comandos") ->
        # verifica se a mensagem do usuário começa com o comando '!comandos'

        Api.Message.create(msg.channel_id, "comandos disponíveis:
        !comandos - mostra os comandos disponíveis.
        !conselho - retorna um conselho aleatório.
        !piada - retorna uma piada aleatória.
        !yn - responde com sim, não ou talvez junto com um gif.
        !numero <numero> - responde um fato interessante sobre o número.
        !gato - mostra a imagem de um gato.
        !filme - retorna um filme aleatório do studio ghibli.
        !pais <nome> - responde informações sobre o país.
        !origem <nome completo> - mostra a origem do nome. ")

      String.starts_with?(msg.content, "!conselho") ->

        case Conselho.fetch_conselho() do
          # chama a função `Conselho.fetch_conselho/0` para buscar um conselho

          {:ok, conselho} ->
            # se a função retornar `{:ok, conselho}`, significa que o conselho foi obtido com sucesso

            Api.Message.create(msg.channel_id, conselho)
            # envia o conselho no canal

          {:error, reason} ->
            # se a função retornar `{:error, reason}`, significa que ocorreu um erro
            Api.Message.create(msg.channel_id, "Erro ao buscar conselho: #{reason}")
            # envia uma mensagem de erro no canal com a razão do erro
        end

      String.starts_with?(msg.content, "!piada") ->

        case Piadas.fetch_piada() do

          {:ok, piada} ->

            Api.Message.create(msg.channel_id, piada)

          {:error, reason} ->

            Api.Message.create(msg.channel_id, "Erro ao buscar piada: #{reason}")

        end

      String.starts_with?(msg.content, "!yn") ->

        case Yn.fetch_yn() do
          # chama a função `Yn.fetch_answer/1` para buscar uma resposta (sim, não ou talvez)

          {:ok, %{answer: answer, image: image_url}} ->
            # se a função retornar `{:ok, %{answer: answer, image: image_url}}`, significa que a resposta foi obtida com sucesso
            Api.Message.create(msg.channel_id, "#{answer}\n#{image_url}")
            # envia a resposta e a URL da imagem no canal

          {:error, reason} ->
            # se a função retornar `{:error, reason}`, significa que ocorreu um erro
            Api.Message.create(msg.channel_id, "Erro ao buscar resposta: #{reason}")
            # envia uma mensagem de erro no canal com a razão do erro
        end

      String.starts_with?(msg.content, "!numero") ->

          numero = String.trim_leading(msg.content, "!numero ") |> String.trim()
          # extrai o número da mensagem, removendo o comando `!numero` e espaços extras

          if numero == "" or not String.match?(numero, ~r/^\d+$/) do
            # se o número não for fornecido ou não for válido, envia uma mensagem de erro
            Api.Message.create(msg.channel_id, "Por favor, forneça um número válido após o comando `!numero`.")
          else
            # converte o número para inteiro e chama a função `Apis.Numeros.fetch_numero/1`
            case Numeros.fetch_numeros(numero) do
              {:ok, %{text: text, number: number}} ->
                # se a função retornar `{:ok, %{text, number, type}}`, significa que o fato foi encontrado
                mensagem = """
                🔢 Fato sobre o número **#{number}**:
                📝 #{text}
                """
                Api.Message.create(msg.channel_id, mensagem)

              {:error, reason} ->
                # se a função retornar `{:error, reason}`, significa que ocorreu um erro
                Api.Message.create(msg.channel_id, "Erro ao buscar o fato sobre o número: #{reason}")
            end
          end

      String.starts_with?(msg.content, "!gato") ->

        case Gatos.fetch_gato() do

          {:ok, image_url} ->

            Api.Message.create(msg.channel_id, image_url)

          {:error, reason} ->

            Api.Message.create(msg.channel_id, "Erro ao buscar imagem de gato: #{reason}")

        end

      String.starts_with?(msg.content, "!ghibli") ->
        # verifica se a mensagem começa com o comando `!filme`.
        case Ghibli.fetch_films() do
          # chama a função `Ghibli.fetch_films/0` para buscar a lista de filmes

          {:ok, films} ->
            # seleciona um filme aleatório da lista
            film = Enum.random(films)

            # extrai informações do filme
            title = film["title"]
            description = film["description"]
            director = film["director"]
            release_date = film["release_date"]

            # formata a mensagem com as informações do filme
            message = """
            🎥 **#{title}** (#{release_date})
            🧑‍🎨 Diretor: #{director}
            📖 Descrição: #{description}
            """

            # envia a mensagem no canal
            Api.Message.create(msg.channel_id, message)

          {:error, reason} ->
            # se a função retornar `{:error, reason}`, significa que ocorreu um erro
            Api.Message.create(msg.channel_id, "Erro ao buscar filmes: #{reason}")
            # envia uma mensagem de erro no canal com a razão do erro
        end

      String.starts_with?(msg.content, "!pais") ->

        nome = String.trim_leading(msg.content, "!pais ") |> String.trim()
        # extrai o nome do país da mensagem, removendo o comando `!pais` e espaços extras

        if nome == "" do
          # se o nome não for fornecido, envia uma mensagem de erro
          Api.Message.create(msg.channel_id, "Por favor, forneça o nome de um país após o comando `!pais`.")
        else
          # chama a função `Apis.Pais.fetch_pais/1` para buscar informações sobre o país
          case Pais.fetch_pais(nome) do
            {:ok, pais} ->
              nome = pais["name"]
              capital = pais["capital"]
              populacao = pais["population"]
              regiao = pais["region"]
              bandeira = pais["flag"]

              # formata a mensagem com as informações do país
              mensagem = """
              🌍 **#{nome}**
              🏛️ Capital: #{capital}
              👥 População: #{populacao}
              🌎 Região: #{regiao}
              🏳️ Bandeira: #{bandeira}
              """

              Api.Message.create(msg.channel_id, mensagem)

              {:error, reason} ->

                Api.Message.create(msg.channel_id, "Erro ao buscar informações do país: #{reason}")
            end
          end

          String.starts_with?(msg.content, "!origem") ->

            nome_completo = String.trim_leading(msg.content, "!origem ") |> String.trim()
            # extrai o nome completo da mensagem, removendo o comando `!origem` e espaços extras

            if nome_completo == "" do
              # se o nome não for fornecido, envia uma mensagem de erro
              Api.Message.create(msg.channel_id, "Por favor, forneça um nome após o comando `!origem`.")
            else
              # divide o nome completo em primeiro nome e sobrenome
              [first_name | last_name_parts] = String.split(nome_completo, " ")
              last_name = Enum.join(last_name_parts, " ")
              # se o nome completo tiver apenas um nome, o sobrenome será vazio

              # chama a função `Apis.Origemnome.fetch_origem_nome/2` para buscar a origem do nome
              case Origemnome.fetch_origem_nome(first_name, last_name) do
                {:ok, %{country_origin: country, region_origin: region}} ->
                  # se a função retornar `{:ok, %{country_origin, region_origin}}`, significa que a origem foi encontrada
                  mensagem = """
                  🌍 Origem do nome **#{nome_completo}**:
                  🏳️ País: #{country}
                  🌎 Região: #{region}
                  """
                  Api.Message.create(msg.channel_id, mensagem)

                {:error, reason} ->

                  Api.Message.create(msg.channel_id, "Erro ao buscar origem do nome: #{reason}")
              end
            end

      true ->
        # caso nenhuma das condições acima seja atendida
        :ignore
        # ignora a mensagem e não faz nada
    end
  end
end

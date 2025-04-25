defmodule Apis.Pais do
  @paisapiurl "https://restcountries.com/v2/name"
  # url da api

  def fetch_pais(nome) do
    # função `fetch_pais/1`, que faz uma requisição para a API e retorna informações sobre o país

    url = "#{@paisapiurl}/#{URI.encode(nome)}"
    # monta a URL com o nome do país fornecido, codificando-o para evitar problemas com caracteres especiais

    case HTTPoison.get(url) do
      # faz uma requisição HTTP GET para a url montada

      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        # se a requisição der certo (status HTTP 200), o corpo da resposta (`body`) é processado

        case Jason.decode(body) do
          # decodifica o corpo da resposta (JSON) em uma lista de mapas Elixir

          {:ok, [pais | _]} ->
            # se o JSON contém uma lista de países, pega o primeiro país da lista
            {:ok, pais}

          _ ->
            # caso o JSON não esteja no formato esperado
            {:error, "Erro ao decodificar a resposta da API"}
            # Retorna um erro indicando que houve um problema ao decodificar o JSON
        end

      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        # caso a requisição retorne um código de status diferente de 200
        {:error, "Erro na API: Código de status #{status_code}"}
        # retorna um erro indicando o código de status HTTP recebido

      {:error, %HTTPoison.Error{reason: reason}} ->
        # caso ocorra um erro de conexão ou outro problema na requisição
        IO.puts("Erro de conexão: #{inspect(reason)}")
        # imprime o erro de conexão no console para depuração
        {:error, "Erro de conexão: #{reason}"}
        # retorna um erro indicando o motivo da falha na conexão
    end
  end
end

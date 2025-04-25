defmodule Apis.Ghibli do
  @ghibliapiurl "https://ghibliapi.vercel.app/films"
  # url da api

  def fetch_films() do
    # função `fetch_films/0`, que faz uma requisição para a API e retorna a lista de filmes

    case HTTPoison.get(@ghibliapiurl) do
      # faz uma requisição HTTP GET para a url

      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        # caso a requisição seja bem-sucedida (status HTTP 200), o corpo da resposta (`body`) é processado

        case Jason.decode(body) do
          # decodifica o corpo da resposta (JSON) em uma lista de mapas Elixir

          {:ok, films} when is_list(films) ->
            # se o JSON contém uma lista de filmes, retorna a lista
            {:ok, films}

          _ ->
            # Caso o JSON não esteja no formato esperado.
            {:error, "Erro ao decodificar a resposta da API"}
            # Retorna um erro indicando que houve um problema ao decodificar o JSON.
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

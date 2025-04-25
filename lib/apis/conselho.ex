defmodule Apis.Conselho do

  @conselhoapiurl "https://api.adviceslip.com/advice"
  # url da api

  def fetch_conselho() do
    # função `fetch_conselho/0`, que faz uma requisição para a API e retorna um conselho

    case HTTPoison.get(@conselhoapiurl) do
      # faz uma requisição HTTP GET para a url

      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        # se a requisição der certo (status HTTP 200), o corpo da resposta (`body`) é processado

        case Jason.decode(body) do
          # decodifica o corpo da resposta (JSON) em um mapa Elixir

          {:ok, %{"slip" => %{"advice" => advice}}} ->
            # se o JSON contém o campo `slip` com o subcampo `advice`, extrai o conselho
            #slip é o objeto principal do JSON retornado, contém informações sobre o conselho fornecido pela API. Dentro do slip, existem subcampos como id e advice
            {:ok, advice}
            # retorna o conselho em um formato `{:ok, advice}`.

          _ ->
            # caso o JSON não esteja no formato esperado
            {:error, "Erro ao decodificar a resposta da API"}
            # retorna um erro indicando que houve um problema ao decodificar o JSON
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

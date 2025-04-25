defmodule Apis.Numeros do
  @numerosapiurl "http://numbersapi.com"
  # url da api

  def fetch_numeros(numero) do
    # função `fetch_numero/1`, que faz uma requisição para a API e retorna um fato sobre o número fornecido

    url = "#{@numerosapiurl}/#{URI.encode(to_string(numero))}/trivia?json"
    # monta a URL com o número fornecido e o formato JSON

    case HTTPoison.get(url) do
      # faz uma requisição HTTP GET para a url

      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        # se a requisição der certo (status HTTP 200), o corpo da resposta (`body`) é processado

        case Jason.decode(body) do
          # decodifica o corpo da resposta (JSON) em um mapa Elixir

          {:ok, %{"text" => text, "number" => number, "type" => type}} ->
            # se o JSON contém os campos `text`, `number` e `type`, retorna os valores
            {:ok, %{text: text, number: number, type: type}}

          _ ->
            # se não (JSON não está no formato esperado)
            {:error, "Erro ao decodificar a resposta da API"}
        end

      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        # caso a requisição retorne um código de status diferente de 200
        {:error, "Erro na API: Código de status #{status_code}"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        # caso ocorra um erro de conexão ou outro problema na requisição.
        {:error, "Erro de conexão: #{reason}"}
    end
  end
end

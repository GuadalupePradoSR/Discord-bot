defmodule Apis.Gatos do
  @gatosapiurl "https://cataas.com/cat"
  # url da api

  def fetch_gato() do
    # função `fetch_gato/0`, que faz uma requisição para a API e retorna a URL da imagem de um gato
    image_url = "#{@gatosapiurl}"

    case HTTPoison.get(@gatosapiurl) do
      # faz uma requisição HTTP GET para a url

      {:ok, %HTTPoison.Response{status_code: 200}} ->
        # caso a requisição seja bem-sucedida (status HTTP 200), retorna a URL da imagem

        {:ok, image_url}
        # retorna a URL da imagem do gato

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

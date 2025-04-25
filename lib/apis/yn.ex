defmodule Apis.Yn do

  @ynapiurl "https://yesno.wtf/api"
  # url da api

  def fetch_yn() do
    # função `fetch_answer/0`, que faz uma requisição para a API e retorna uma resposta

    case HTTPoison.get(@ynapiurl) do
      # faz uma requisição HTTP GET para a URL base

      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        # caso a requisição seja bem-sucedida (status HTTP 200), o corpo da resposta (`body`) é processado

        case Jason.decode(body) do
          # decodifica o corpo da resposta (JSON) em um mapa Elixir

          {:ok, %{"answer" => answer, "image" => image_url}} ->
            # se o JSON contém os campos `answer` e `image`, extrai os valores
            # `answer` contém a resposta (yes, no ou maybe)
            # `image` contém a URL de um GIF correspondente à resposta

            {:ok, %{answer: answer, image: image_url}}
            # retorna a resposta e a URL da imagem

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

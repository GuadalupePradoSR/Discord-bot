defmodule Apis.Piadas do

  @piadaapiurl "https://v2.jokeapi.dev/joke/Any"
  # url da api

  def fetch_piada() do
    # função `fetch_piada/0`, que faz uma requisição para a API e retorna uma piada

    case HTTPoison.get(@piadaapiurl) do
      # faz uma requisição HTTP GET para a url

      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        # caso a requisição seja bem-sucedida (status HTTP 200), o corpo da resposta (`body`) é processado

        case Jason.decode(body) do
          # decodifica o corpo da resposta (JSON) em um mapa Elixir

          #type determina o processo do tipo de piada
          {:ok, %{"type" => "single", "joke" => joke}} ->
            # se o JSON contém o campo `type` com o valor `single`, extrai a piada do campo `joke`
            # single - uma linha, piada simples
            # joke é presente apenas quando type é single
            {:ok, joke}
            # retorna a piada em um formato `{:ok, joke}`

          {:ok, %{"type" => "twopart", "setup" => setup, "delivery" => delivery}} ->
            # se o JSON contém o campo `type` com o valor `twopart`, extrai os campos `setup` e `delivery`
            # twopart - duas partes, setup e delivery
            # setup/delivery é presente apenas quanto type é twopart
            {:ok, "#{setup} - #{delivery}"}
            # retorna a piada formatada como `setup - delivery` em um formato `{:ok, piada}`

          _ ->
            # caso o JSON não esteja no formato esperado
            {:error, "Erro ao decodificar a resposta da API"}
            # retorna um erro indicando que houve um problema ao decodificar o JSON
        end

      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        # caso a requisição retorne um código de status diferente de 200
        {:error, "Erro na API: Código de status #{status_code}"}
        # ertorna um erro indicando o código de status HTTP recebido

      {:error, %HTTPoison.Error{reason: reason}} ->
        # caso ocorra um erro de conexão ou outro problema na requisição
        IO.puts("Erro de conexão: #{inspect(reason)}")
        # imprime o erro de conexão no console para depuração
        {:error, "Erro de conexão: #{reason}"}
        # retorna um erro indicando o motivo da falha na conexão
    end
  end
end

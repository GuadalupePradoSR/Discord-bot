defmodule Apis.Origemnome do
  @nomeorigemurl "https://v2.namsor.com/NamSorAPIv2"
  @nomeorigemkey System.get_env("ORIGEM_NOME_TOKEN")
  # url da api e a chave de autenticação

  @spec fetch_origem_nome(any()) ::
          {:error, <<_::64, _::_*8>>} | {:ok, %{country_origin: any(), region_origin: any()}}
  def fetch_origem_nome(first_name, last_name \\ "") do
    # função `fetch_origem_nome/2`, que faz uma requisição para a API e retorna a origem do nome

    url = "#{@nomeorigemurl}/api2/json/originBatch"
    # a rota correta para enviar uma matriz de nomes é `/api2/json/originBatch`.

    headers = [
      {"X-API-KEY", @nomeorigemkey},
      {"Content-Type", "application/json"}
    ]
    # define os cabeçalhos da requisição, incluindo a chave de autenticação e o tipo de conteúdo

    body = %{
      personalNames: [
        %{
          firstName: first_name,
          lastName: last_name
        }
      ]
    }
    |> Jason.encode!()
    # monta o corpo da requisição no formato JSON

    case HTTPoison.post(url, body, headers) do
      # faz uma requisição HTTP POST para a URL montada com o corpo e os cabeçalhos

      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        # se a requisição der certo (status HTTP 200), o corpo da resposta (`body`) é processado

        case Jason.decode(body) do
          # decodifica o corpo da resposta (JSON) em um mapa Elixir

          {:ok, %{"personalNames" => [%{"countryOrigin" => country_origin, "regionOrigin" => region_origin}]}} ->
            # se o JSON contém os campos `countryOrigin` e `regionOrigin`, retorna os valores
            {:ok, %{country_origin: country_origin, region_origin: region_origin}}

          _ ->
            # se não (JSON não está no formato esperado)
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

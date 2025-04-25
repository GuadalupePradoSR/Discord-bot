defmodule Discordbot.Application do

    use Application

    @impl true
    def start(_start_type, _start_args) do
        children = [
            Discordbot
        ]

        opts = [strategy: :one_for_one, name: Discordbot.Supervisor]
        Supervisor.start_link(children, opts)

    end

end

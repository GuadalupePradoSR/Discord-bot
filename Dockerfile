FROM elixir:1.18.3

WORKDIR /usr/src/discordbot

COPY . .

RUN mix local.hex --force && mix local.rebar --force && mix deps.get

#CMD ["iex", "-S", "mix"]
CMD ["mix", "run", "--no-halt"]
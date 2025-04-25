<<<<<<< HEAD
# Discordbot

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `discordbot` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:discordbot, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/discordbot>.
=======
# Discord-bot
Discord bot using the Elixir functional programming language, it has 9 commands, each of which consumes a different Rest API. A Dockerfile and Docker Compose were created for the bot, allowing it to be run from a container.

The 10 APIs used were: CATAAS (returns an image of a cat), Yes Or No? (returns a message that can be “yes”, “no” or “maybe” and along with the message comes a gif related to one of these 3 answers), REST Countries (the user enters the name of a country and basic information about that country is returned), Numbers (the user enters a number and a random fact about that number is returned), Advice Slip (returns advice), Joke (returns a joke), Studio Ghibli (returns information about a random Studio Ghibli film), Namsor (the user enters any first and last name and the country and region of origin of those names are returned).

ATTENTION:

*All APIs used are free, however some require an API Key to be consumed. If you want to know more details and how to generate your own API Key, check the documentation for each API.

*When using the project, edit the compose.yml.example to compose.yml and replace the TOKENS with your own.

API LINKS:

names: https://namsor.app/ 

numbers: http://numbersapi.com/#42 

cat: https://cataas.com/ 

yes or no: https://yesno.wtf/ 

countries: https://restcountries.com/ 

studio ghibli: https://ghibliapi.vercel.app/# 

advice slip: https://api.adviceslip.com/ 

joke: https://v2.jokeapi.dev/ 


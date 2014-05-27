defmodule Celebipsum do
  use Application.Behaviour

  # See http://elixir-lang.org/docs/stable/Application.Behaviour.html
  # for more information on OTP Applications
  def start(_type, _args) do
    Celebipsum.Supervisor.start_link
  end

  def parse(in_string) do
    string_to_dict(in_string, %{})
  end

  def string_to_dict(in_string, current_dict) do
    case String.split(in_string, ~r{\s+}, parts: 4, trim: true) do
      [first, second, third, rest] ->
        new_dict = Dict.put(%{}, "#{first} #{second}", [String.strip(third)])
        rest_dict = string_to_dict("#{second} #{third} #{rest}", new_dict)
        markovmerge(current_dict, rest_dict)
      [first, second, rest] ->
        rest_dict = Dict.put(%{}, "#{first} #{second}", [String.strip(rest)])
        markovmerge(current_dict, rest_dict)
      _ ->
        markovmerge(current_dict, %{})
    end
  end

  def markovmerge(d1, d2) do
    Dict.merge(d1, d2, fn _k, v1, v2 -> v1 ++ v2 end)
  end

  def readcorpus do
    {:ok, in_string} = File.read "corpus.txt"
    parse(in_string)
  end

end

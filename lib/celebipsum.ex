defmodule Celebipsum do
  use Application.Behaviour

  def start(_type, _args) do
    Celebipsum.Supervisor.start_link
  end

  def parse(in_string) do
    string_to_dict(in_string, %{})
  end

  def string_to_dict(in_string, current_dict) do
    case String.split(in_string, ~r{\s+}, parts: 4, trim: true) do
      [first, second, third, rest] ->
        new_dict = dict_from_triple(first, second, third)
        rest_dict = string_to_dict("#{second} #{third} #{rest}", new_dict)
        markovmerge(current_dict, rest_dict)
      [first, second, third] ->
        rest_dict = dict_from_triple(first, second, third)
        markovmerge(current_dict, rest_dict)
      _ ->
        markovmerge(current_dict, newdict())
    end
  end

  def dict_from_triple(first, second, third) do
    key = [first, second]
    Dict.put(newdict(), key, [String.strip(third)])
  end

  def newdict() do
    HashDict.new()
  end

  def markovmerge(d1, d2) do
    Dict.merge(d1, d2, fn _k, v1, v2 -> v1 ++ v2 end)
  end

  def readcorpus do
    {:ok, in_string} = File.read "corpus.txt"
    IO.puts inspect(parse(in_string))
  end

## generation

  def word_list(corpus, count) do
    _word_list([], corpus, [], count)
  end

  #def _word_list(_, _, 0), do: []
  def _word_list(sofar, corpus, _, count) when count < 3 do
    sofar ++
    corpus
    |> Dict.keys
    |> Enum.shuffle
    |> Enum.fetch!(0)
    |> Enum.take(count)
  end

  def _word_list(scorpus, _, count) when count >= 3 do
    [one, two] = word_list(corpus, 2)
    [one, two] ++ _word_list(corpus, one, two, count - 2)
  end

  def _word_list(corpus, prev2, prev1, _count) do
    Dict.fetch!(corpus, [prev2, prev1])
    |> Enum.shuffle
    |> Enum.fetch!(0)
    |> List.wrap
  end

end

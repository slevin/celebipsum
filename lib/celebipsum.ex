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
    parse(in_string)
  end

## generation

  def word_list(corpus, count) do
    _word_list([], corpus, [], count)
  end

  def _word_list([], corpus, [], count) when count < 3 do
    corpus
    |> Dict.keys
    |> Enum.shuffle
    |> Enum.fetch!(0)
    |> Enum.take(count)
  end

  def _word_list([], corpus, [], count) when count >= 3 do
    [one, two] = _word_list([], corpus, [], 2)
    _word_list([one, two], corpus, [one, two], count)
  end

  def _word_list(sofar, corpus, [prev2, prev1], count) when length(sofar) < count do
    follower = follower(corpus, prev2, prev1)
    _word_list(sofar ++ [follower], corpus, [prev1, follower], count)
  end

  def _word_list(sofar, _, _, count) when length(sofar) >= count do
    sofar
  end

  def follower(corpus, prev2, prev1) do
    Dict.fetch!(corpus, [prev2, prev1])
    |> Enum.shuffle
    |> Enum.fetch!(0)
  end

  def generate(length) do
    :random.seed(:erlang.now)
    readcorpus()
    |> word_list(length)
    |> Enum.join(" ")
    |> IO.puts
  end

end

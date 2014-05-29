defmodule Celebipsum.Reader do

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

end
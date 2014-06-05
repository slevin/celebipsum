defmodule Celebipsum.Reader do

  def parse(in_string) do
    String.split(in_string, ~r{\s+}, strip: true)
    |> Enum.chunk(3,1)
    |> Enum.map(fn([first, second, third]) ->
                    Dict.put(newdict, [first, second], [String.strip(third)])
                end)
    |> Enum.reduce(fn(current, acc) ->
                       Dict.merge(acc, current, fn(_k, l1, l2) -> l1 ++ l2 end)
                   end)
  end

  def newdict() do
    HashDict.new()
  end

  def readcorpus do
    {:ok, in_string} = File.read "corpus.txt"
    parse(in_string)
  end

end
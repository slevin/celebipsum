defmodule Celebipsum.Generator do

  def word_list(corpus, count) do
    _word_list([], corpus, [], count)
  end

  def _word_list([], corpus, [], count) when count < 3 do
    corpus
    |> Dict.keys
    |> Enum.filter(fn x -> good_first_words(x) end)
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

  def generate(corpus, length) do
    corpus
    |> word_list(length)
    |> Enum.join(" ")
  end

  def doall(length) do
    :random.seed(:erlang.now)
    generate(Reader.readcorpus(), length)
    |> IO.puts
  end

  def good_first_words([first, second | []]) do
    # first is capitalized and not begin or end in punctuation
    # second does not begin or end in punctuation
    Regex.match?(~r/^[^\p{P}\p{Ll}].*\P{P}$/, first) and
                    Regex.match?(~r/^\P{P}.*\P{P}$/, second)
  end
end
defmodule CelebipsumTest do
  use ExUnit.Case

  import Celebipsum

  test "empty strings are skipped" do
    res = parse("")
    assert Dict.equal?(res, %{})
  end

  test "single words are skipped" do
    res = Celebipsum.parse("one")
    assert Dict.equal?(res, %{})
  end

  test "double words are skipped" do
    res = Celebipsum.parse("one two")
    assert Dict.equal?(res, %{})
  end

  test "triples are stored in a dict" do
    res = Celebipsum.parse("one two three")
    assert Dict.equal?(res, %{~w{one two} => ["three"]})
  end

  test "merge builds lists" do
    d1 = %{~w{one two} => ["a"]}
    d2 = %{~w{one two} => ["b"]}
    res = markovmerge(d1, d2)
    assert res ===  %{~w{one two} => ["a", "b"]}
  end

  test "second tripple also stored in same dict" do
    res = parse("one two three four")
    answer = %{~w{one two} => ["three"], ~w{two three} => ["four"]}
    assert Dict.equal?(res, answer), res, answer, "dicts not equal"
  end

  test "merges duplicates" do
    res = parse("one one one two")
    answer = %{~w{one one} => ["one", "two"]}
    assert Dict.equal?(res, answer), res, answer, "dicts not equal"
  end

  test "ignores extra whitespace" do
    res = parse("\n  one  two\n\t  three   ")
    answer = %{~w{one two} => ["three"]}
    assert Dict.equal?(res, answer), res, answer, "dicts not equal"
  end

## generation tests

  test "generate 0 words generates empty list" do
    corpus = %{~w{one two} => ["three"]}
    list = word_list(corpus, 0)
    assert list === []
  end

  test "generate 1 word generates one from possibilities" do
    corpus = %{~w{one two} => ["three"]}
    list = word_list(corpus, 1)
    assert list === ["one"]
  end

  test "generate 2 words generates one from possibilities" do
    corpus = %{~w{one two} => ["three"]}
    list = word_list(corpus, 2)
    assert list === ["one", "two"]
  end

  test "generate 3 words generates one from possibilities" do
    corpus = %{~w{one two} => ["three"]}
    list = word_list(corpus, 3)
    assert list === ["one", "two", "three"]
  end

  test "generate 4 words generates one from possibilities" do
    corpus = %{~w{one two} => ["three"], ~w{two three} => ["four"]}
    list = word_list(corpus, 4)
    assert list === ["one", "two", "three", "four"]
  end



# test picking random

# test picking random next based on previous input

# test generating a result set based on input

# could do some capital/punctuation normalization
# but that would mess with things to some degree
# because first and last words have some meaning
# even if there's less overlap

end

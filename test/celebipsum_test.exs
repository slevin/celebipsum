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

# test that same initals are stored in list if different
# and if same

# test parsing io stream in

# test picking random

# test picking random next based on previous input

# test generating a result set based on input



  # test "words are stored decapitalized" do
  #   res = Celebipsum.parse("One Two Three")
  #   assert Dict.equal?(res, %{"one two" => ["three"]})
  # end



  # compare two hashdicts

  # test "text stream parser returns first word" do
  #   first = first_word("one two three")
  #   assert first == "one"
  # end

end

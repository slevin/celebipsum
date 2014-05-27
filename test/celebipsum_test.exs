defmodule CelebipsumTest do
  use ExUnit.Case

  import C
  test "text stream parser returns first word" do
    first = first_word("one two three")
    assert first == "one"
  end

end

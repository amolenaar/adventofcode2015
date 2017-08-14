defmodule Day5 do
  use ExUnit.Case

  def strings do
    {:ok, lines} = File.open("test/day_5_input.txt", [:read], fn(file) ->
      IO.stream(file, :line) |> Enum.map(&String.to_charlist/1) |> Enum.to_list
    end)
    lines
  end

  # contains 3 of "aeiou"
  def three_vowels(s) do
    vowels = s |> Enum.filter(fn c -> c in 'aeiou' end) |> Enum.count
    vowels >= 3
  end

  # It contains at least one letter that appears twice in a row, like xx, abcdde (dd), or aabbccdd (aa, bb, cc, or dd).
  def double_letter(s) do
    Enum.reduce_while(s, -1, fn c, acc -> if c == acc, do: {:halt, true}, else: {:cont, c} end) == true
  end

  # It does not contain the strings ab, cd, pq, or xy, even if they are part of one of the other requirements.
  def illegal_sequence(s) do
    illegal = ['ab', 'cd', 'pq', 'xy']
    Enum.reduce_while(s, -1, fn c, acc -> if [acc, c] in illegal, do: {:halt, true}, else: {:cont, c} end) == true
  end

  # It contains a pair of any two letters that appears at least twice in the
  # string without overlapping, like xyxy (xy) or aabcdefgaa (aa), but not like aaa (aa, but it overlaps).
  # Find pairs -> Split by 2, split by 2 offset 1
  # Check for a duplicate
  def appear_twice([_]), do: false
  def appear_twice([a, b | rest]) do
#    IO.inspect "#{l} #{[a]} #{[b]} #{rest}"
#    IO.inspect Enum.scan(rest, fn c, d -> [d, c] == [a, b] end) # |> Enum.find(fn a -> a end)
    if Enum.scan(rest, false, fn d, c -> if [c, d] == [a, b], do: true, else: d end) |> Enum.find(fn a -> a == true end) do
      true
    else
      appear_twice([b | rest])
    end
  end
  

  def repeat_with_one_letter_in_between(s) do
    # It contains at least one letter which repeats with exactly one letter between them, like xyx,
    # abcdefeghi (efe), or even aaa.
    Enum.reduce_while(s, {-1, -1}, fn c, {a, b} -> if a == c, do: {:halt, true}, else: {:cont, {b, c}} end) == true
  end

  test "day 5 one functions" do
    # assert "aap" == 3
    assert three_vowels('aiu')
    assert not three_vowels('vip')
    assert double_letter('arrjan')
    assert not double_letter('arjan')
    assert illegal_sequence('foocdfoo')
    assert not illegal_sequence('arjan')
    assert appear_twice('qjhvhtzxzqqjkmpb')
    assert false == appear_twice('arjan')
    assert repeat_with_one_letter_in_between('ariana')
    assert not repeat_with_one_letter_in_between('arjan')
  end

  test "day 5 one" do
    result = strings()
    |> Enum.filter(fn s ->
         three_vowels(s) and double_letter(s) and not illegal_sequence(s)
       end)
    |> Enum.count
    assert result == 236
  end

  test "day 5 two" do
    result = strings()
    |> Enum.filter(fn s ->
         appear_twice(s) and repeat_with_one_letter_in_between(s)
       end)
    |> Enum.count
    assert result == 51
  end
end

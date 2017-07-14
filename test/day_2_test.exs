defmodule Day1 do
  use ExUnit.Case

  test "part one" do
    IO.puts go_floor(@input, 0)
  end

  test "part two" do
    len = go_floor(@input, 0)
    IO.puts Enum.count(@input) - Enum.count(len)
  end
  
  def go_floor(l, floor) when floor < 0, do: l
  def go_floor([@open | rest], floor), do: go_floor rest, floor + 1
  def go_floor([@close | rest], floor), do: go_floor rest, floor - 1
  def go_floor([], floor), do: floor

end

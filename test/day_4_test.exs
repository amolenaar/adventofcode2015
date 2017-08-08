defmodule Day4 do
  use ExUnit.Case

  @input 'yzbqklnj'
  #@input 'bgvyzdsv' # Jochum's secret


  test "day 4 one" do
    #assert mine('abcdef') == 609043
    #assert mine('pqrstuv') == 1048970
    assert mine5(@input) == 282749
  end

  def mine5(key, n \\ 1) do
    case md5(key ++ Integer.to_charlist(n)) do
      "00000" <> _ -> n
      _ -> mine5(key, n+1)
    end
  end

  test "day 4 two" do
    assert mine6(@input) == 9962624
  end

  def mine6(key, n \\ 1) do
    case md5(key ++ Integer.to_charlist(n)) do
      "000000" <> _ -> n
      _ -> mine6(key, n+1)
    end
  end

  def md5(s), do: :crypto.hash(:md5, s) |> Base.encode16()

end

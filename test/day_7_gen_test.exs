defmodule Day7Test do
  use ExUnit.Case
  use Bitwise

  import DefMemo

  defmodule Parser do
    def parse_line(["NOT", in1, "->", out]), do: {:bnot, [parse_input(in1)], out}
    def parse_line([in1, "OR", in2, "->", out]), do: {:|||, [parse_input(in1), parse_input(in2)], out}
    def parse_line([in1, "AND", in2, "->", out]), do: {:&&&, [parse_input(in1), parse_input(in2)], out}
    def parse_line([in1, "LSHIFT", in2, "->", out]), do: {:<<<, [parse_input(in1), parse_input(in2)], out}
    def parse_line([in1, "RSHIFT", in2, "->", out]), do: {:>>>, [parse_input(in1), parse_input(in2)], out}
    def parse_line([in1, "->", out]), do: {:set, [parse_input(in1)], out}

    def parse_input(input) do
      case Integer.parse(input) do
        {n, ""} -> n
        :error -> input
      end
    end
  end

  {:ok, lines} = File.open("test/day_7_input.txt", [:read], fn(file) ->
    IO.stream(file, :line)
    |> Enum.map(&String.split/1)
    |> Enum.map(&Parser.parse_line/1)
  end)

  defmemo doit(n) when is_integer(n) do
    n
  end

  for {oper, args, out} <- lines do
    case {oper, args} do
      {:set, [val]} when is_integer(val) ->
        defmemo doit(unquote(out)) do
          unquote(val)
        end
      {:set, [val]} ->
        defmemo doit(unquote(out)) do
          doit(unquote(val))
        end
      {oper, [arg1]} ->
        defmemo doit(unquote(out)) do
          unquote(oper)(doit(unquote(arg1)))
        end
      {oper, [arg1, arg2]} ->
        defmemo doit(unquote(out)) do
          unquote(oper)(doit(unquote(arg1)), doit(unquote(arg2)))
        end
      huh ->
        raise "Unknown statement #{inspect huh} -> #{out}"
    end
  end

  test "day 7 part one" do
    assert doit("a") == 3176
  end

end

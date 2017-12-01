defmodule Day7Test do
  use ExUnit.Case
  use Bitwise

  def read_circuit() do
    {:ok, lines} = File.open("test/day_7_input.txt", [:read], fn(file) ->
        IO.stream(file, :line)
        |> Enum.map(&String.split/1)
        |> Enum.map(&parse_line/1)
        #|> Enum.reduce(%{}, fn({oper, inputs, output}, circuit) -> Map.put(circuit, output, {oper, inputs}) end)
      end)
    lines
  end

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


  # for each item in circuit -> 
    # replace inputs with value
    # Register output if all inputs are integers
    # replace gate with wire assignment
  # 

  def do_oper(:set, in1), do: in1
  def do_oper(:bnot, in1), do: bnot(in1)
  def do_oper(:|||, in1, in2), do: in1 ||| in2
  def do_oper(:&&&, in1, in2), do: in1 &&& in2
  def do_oper(:<<<, in1, in2), do: in1 <<< in2
  def do_oper(:>>>, in1, in2), do: in1 >>> in2

  def find_outputs([instr | circuit], outputs) do
    case instr do
      {oper, [in1], out} when is_number(in1) ->
        find_outputs circuit, Map.put(outputs, out, do_oper(oper, in1))
	
      {oper, [in1, in2], out} when is_number(in1) and is_number(in2) ->
        find_outputs circuit, Map.put(outputs, out, do_oper(oper, in1, in2))
      _ ->
        find_outputs circuit, outputs
    end
  end

  def find_outputs([], outputs), do: outputs
    
  def replace_inputs(inputs, outputs) do
    inputs |> Enum.map(fn a -> Map.get(outputs, a, a) end)
  end

  def apply_outputs(circuit, outputs) do
    circuit |> Enum.map(fn {oper, ins, out} -> {oper, replace_inputs(ins, outputs), out} end)
  end

  def backtrack_wire(wire, circuit) do
    outputs = find_outputs circuit, %{}
    if Map.get(outputs, wire) do
      Map.get(outputs, wire)
    else
      circuit = apply_outputs(circuit, outputs)
      backtrack_wire(wire, circuit)
    end
  end

  test "day 7 part one" do
    circuit = read_circuit()
    assert backtrack_wire("a", circuit) == 3176
  end

  test "day 7 part two" do

  end
end

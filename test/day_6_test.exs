defmodule Day6Test do
    use ExUnit.Case

    def strings do
      {:ok, lines} = File.open("test/day_6_input.txt", [:read], fn(file) ->
          IO.stream(file, :line) |> Enum.map(&parse_line/1) |> Enum.to_list
        end)
      lines
    end
    
    def parse_line("turn on " <> line) do
        [start_pos, "through", end_pos] = String.split(line)
        {:turn_on, to_coord(start_pos), to_coord(end_pos)}
    end

    def parse_line("turn off " <> line) do
        [start_pos, "through", end_pos] = String.split(line)
        {:turn_off, to_coord(start_pos), to_coord(end_pos)}
    end

    def parse_line("toggle " <> line) do
        [start_pos, "through", end_pos] = String.split(line)
        {:toggle, to_coord(start_pos), to_coord(end_pos)}
    end

    def to_coord(coord) do
        coord
        |> String.split(",")
        |> Enum.map(&String.to_integer/1)
        |> List.to_tuple
    end

    def coords({x1, y1}, {x2, y2}) do
        for x <- x1..x2,
            y <- y1..y2,
            do: {x, y}
    end

    def switch({:turn_on, start_pos, end_pos}, lights) do
        coords(start_pos, end_pos) |> Enum.reduce(lights, fn(pos, lights) -> Map.put(lights, pos, :on) end)
    end

    def switch({:turn_off, start_pos, end_pos}, lights) do
        coords(start_pos, end_pos) |> Enum.reduce(lights, fn(pos, lights) -> Map.delete(lights, pos) end)
    end

    def switch({:toggle, start_pos, end_pos}, lights) do
        coords(start_pos, end_pos) |> Enum.reduce(lights, fn(pos, lights) ->
            if Map.has_key?(lights, pos) do
                Map.delete(lights, pos)
            else
                Map.put(lights, pos, :on)
            end
        end)
    end

    def brightness({:turn_on, start_pos, end_pos}, lights) do
        coords(start_pos, end_pos) |> Enum.reduce(lights, fn(pos, lights) -> Map.update(lights, pos, 1, fn (v) -> v+1 end) end)
    end

    def brightness({:turn_off, start_pos, end_pos}, lights) do
        coords(start_pos, end_pos) |> Enum.reduce(lights, fn(pos, lights) -> Map.update(lights, pos, 0, fn v -> max(0, v-1) end) end)
    end

    def brightness({:toggle, start_pos, end_pos}, lights) do
        coords(start_pos, end_pos) |> Enum.reduce(lights, fn(pos, lights) -> Map.update(lights, pos, 2, fn (v) -> v+2 end) end)
    end

    test "parse line" do
        assert parse_line("turn on 80,957 through 776,968") == {:turn_on, {80, 957}, {776, 968}}    
    end

    test "switch turn on" do
        assert switch({:turn_on, {1, 1}, {2, 2}}, %{}) == %{{1,1} => :on, {1,2} => :on, {2,1} => :on, {2,2} => :on}
    end

    test "switch turn off" do
        assert switch({:turn_off, {1, 1}, {1, 1}}, %{{1,1} => :on, {1,2} => :on}) == %{{1,2} => :on}
    end

    test "switch toggle" do
        assert switch({:toggle, {1, 1}, {2, 2}}, %{{1,1} => :on, {1,2} => :on}) == %{{2,1} => :on, {2,2} => :on}
    end

    test "brightness" do
        assert brightness({:turn_on, {1, 1}, {2, 2}}, %{}) == %{{1,1} => 1, {1,2} => 1, {2,1} => 1, {2,2} => 1}
        assert brightness({:turn_off, {1, 1}, {2, 2}}, %{{1,1} => 2, {1,2} => 3}) == %{{1,1} => 1, {1,2} => 2, {2,1} => 0, {2,2} => 0}
        assert brightness({:toggle, {1, 1}, {2, 2}}, %{{1,1} => 2, {1,2} => 3}) == %{{1,1} => 4, {1,2} => 5, {2,1} => 2, {2,2} => 2}
    end

    test "day 6 part one" do
        lights = strings() |> Enum.reduce(%{}, &switch/2)
        assert Enum.count(lights) == 543903
    end

    test "day 6 part two" do
        lights = strings() |> Enum.reduce(%{}, &brightness/2)
        assert Map.values(lights) |> Enum.sum() == 14687245
    end
end
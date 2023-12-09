defmodule Day09 do

  def part1() do
    read_input()
    |> Enum.map(&predict_value(&1, MapSet.size(MapSet.new(&1))>1))
    |> Enum.sum()
    |> IO.inspect()
  end

  def part2() do
    read_input()
    |> Enum.map(&extrapolate_value(&1, MapSet.size(MapSet.new(&1))>1))
    |> Enum.sum()
    |> IO.inspect()
  end

  defp predict_value(values, false) do List.first(values) end
  defp predict_value(values, true) do
    diffs = values
    |> Stream.chunk_every(2,1, :discard) |> Enum.to_list()
    |> Enum.map(fn [v1, v2] -> v2-v1 end)

    Enum.at(values, -1) + predict_value(diffs, MapSet.size(MapSet.new(diffs))>1)
  end

  defp extrapolate_value(values, false) do List.first(values) end
  defp extrapolate_value(values, true) do
    diffs = values
    |> Stream.chunk_every(2,1, :discard) |> Enum.to_list()
    |> Enum.map(fn [v1, v2] -> v2-v1 end)

    List.first(values) - extrapolate_value(diffs, MapSet.size(MapSet.new(diffs))>1)
  end

  defp read_input() do
    File.read(Path.dirname(__ENV__.file) <> "/day09.input")
    |> elem(1)
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(" ", trim: true)
      |> Enum.map(fn v -> Integer.parse(v) |> elem(0) end)
    end)
  end

end

time_t1 = NaiveDateTime.utc_now
Day09.part1()
time_t2 = NaiveDateTime.utc_now
Day09.part2()
time_t3 = NaiveDateTime.utc_now
IO.puts("Time p1: " <> Integer.to_string(NaiveDateTime.diff(time_t2, time_t1, :millisecond))<> "ms")
IO.puts("Time p2: " <> Integer.to_string(NaiveDateTime.diff(time_t3, time_t2, :millisecond))<> "ms")

defmodule Day00 do

  def part1() do
    unviverse = read_input()

    galaxy_pos = unviverse
    |> Enum.filter(fn {_pos, px} -> px=="#" end) |> Enum.map(fn {pos, _} -> pos end)

    {non_empty_rows, non_empty_cols} =
      galaxy_pos |> Enum.reduce({MapSet.new(), MapSet.new()}, fn {row,col}, {rows, cols} -> {MapSet.put(rows, row), MapSet.put(cols, col)} end)

    galaxy_pairs = for g1 <- galaxy_pos, g2 <- galaxy_pos, g1 != g2, do: [g1, g2]

    distances = galaxy_pairs
    |> Enum.map(fn [g1, g2] -> distance(g1, g2, non_empty_rows, non_empty_cols, 2) end)
    |> Enum.sum()

    IO.puts(distances/2)

  end

  def part2() do
    unviverse = read_input()

    galaxy_pos = unviverse
    |> Enum.filter(fn {_pos, px} -> px=="#" end) |> Enum.map(fn {pos, _} -> pos end)

    {non_empty_rows, non_empty_cols} =
      galaxy_pos |> Enum.reduce({MapSet.new(), MapSet.new()}, fn {row,col}, {rows, cols} -> {MapSet.put(rows, row), MapSet.put(cols, col)} end)

    galaxy_pairs = for g1 <- galaxy_pos, g2 <- galaxy_pos, g1 != g2, do: [g1, g2]

    distances = galaxy_pairs
    |> Enum.map(fn [g1, g2] -> distance(g1, g2, non_empty_rows, non_empty_cols, 1_000_000) end)
    |> Enum.sum()

    IO.puts(distances/2)
  end

  defp distance({r1, c1}, {r2, c2}, nempty_rows, nempty_cols, expansion) do
    passed_rows = MapSet.new(Enum.to_list(r1..r2))
    passed_cols = MapSet.new(Enum.to_list(c1..c2))

    nr_passed_empty_rows = MapSet.size(MapSet.difference(passed_rows, nempty_rows))
    nr_passed_empty_cols = MapSet.size(MapSet.difference(passed_cols, nempty_cols))
    abs(r1-r2) + abs(c1-c2) + (expansion-1)*nr_passed_empty_rows + (expansion-1)*nr_passed_empty_cols
  end

  defp read_input() do
    File.read(Path.dirname(__ENV__.file) <> "/day11.input")
    |> elem(1)
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, row} ->
      line |> String.codepoints() |> Enum.with_index() |> Enum.map(fn {sign, col} -> {{row, col}, sign} end)
    end)
    |> Enum.into(%{})
  end

end

time_t1 = NaiveDateTime.utc_now
Day00.part1()
time_t2 = NaiveDateTime.utc_now
Day00.part2()
time_t3 = NaiveDateTime.utc_now
IO.puts("Time p1: " <> Integer.to_string(NaiveDateTime.diff(time_t2, time_t1, :millisecond))<> "ms")
IO.puts("Time p2: " <> Integer.to_string(NaiveDateTime.diff(time_t3, time_t2, :millisecond))<> "ms")

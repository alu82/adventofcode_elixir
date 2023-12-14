defmodule Day14 do

  def part1() do
    solve(0)
  end

  def part2() do
    solve(1_000_000_000)
  end

  defp solve(cycles) do
    map = read_input()

    {cycled_map, _cache, last_run, seen_at} =
      Enum.reduce_while(0..cycles, {map, %{}, 0, 0}, fn idx, {map, cache, _run, _seen} -> cycle(map, cache, idx) end)

    last_map =
      if last_run < cycles do
        remaining_cycles = rem(cycles - last_run, last_run - seen_at)
        Enum.reduce_while(1..remaining_cycles, {cycled_map, %{}, 0, 0}, fn idx, {map, cache, _run, _seen} -> cycle(map, cache, idx) end) |> elem(0)
      else
        cycled_map
      end

    last_map
    |> Enum.map(&(String.codepoints(&1)))
    |> Enum.zip()
    |> Enum.map(&(List.to_string(Tuple.to_list(&1))))
    |> Enum.map(fn c ->
      case cycles do
        0 -> roll_rocks(c)
        _ -> c
      end
    end)
    |> Enum.map(&calc_load(&1, String.length(&1)))
    |> Enum.sum()
  end

  defp cycle(map, cache, 0) do {:cont, {map, Map.put(cache, map, 0), 0, 0}} end
  defp cycle(map, cache, run) do
    updated_map = cycle(map)
    case Map.get(cache, updated_map) do
      nil -> {:cont, {updated_map, Map.put(cache, updated_map, run), run, nil}}
      seen_at -> {:halt, {updated_map, cache, run, seen_at}}
    end
  end

  defp cycle(map) do
    map
    |> tilts() |> Enum.map(&roll_rocks/1)
    |> tilts() |> Enum.map(&roll_rocks/1)
    |> tilts() |> Enum.map(&String.reverse/1) |> Enum.map(&roll_rocks/1)
    |> tilts() |> Enum.map(&String.reverse/1) |> Enum.map(&roll_rocks/1)
    |> Enum.map(&String.reverse/1) |> Enum.reverse()
  end

  defp tilts(map) do
    map
    |> Enum.map(&(String.codepoints(&1)))
    |> Enum.zip() |> Enum.map(&(List.to_string(Tuple.to_list(&1))))
  end

  defp calc_load("", _weight) do 0 end
  defp calc_load(col, weight) do
    {current, next_col} = String.split_at(col, 1)
    cond do
      current == "O" -> weight + calc_load(next_col, weight-1)
      true -> calc_load(next_col, weight-1)
    end
  end

  defp roll_rocks("") do "" end
  defp roll_rocks(col) do
    cond do
      String.contains?(col, "#") ->
        String.split(col, "#")
        |> Enum.map(&roll_rocks/1)
        |> Stream.intersperse("#")
        |> Enum.to_list()
        |> List.to_string()
      String.at(col, 0)=="." -> roll_rocks(String.slice(col, 1, String.length(col))) <> "."
      String.at(col, 0)=="O" -> "O" <> roll_rocks(String.slice(col, 1, String.length(col)))
    end
  end

  defp read_input() do
    File.read(Path.dirname(__ENV__.file) <> "/day14.input")
    |> elem(1)
    |> String.split("\n", trim: true)
    |> Enum.map(fn line -> line end)
  end

end

time_t1 = NaiveDateTime.utc_now
Day14.part1() |> IO.inspect(label: "p1")
time_t2 = NaiveDateTime.utc_now
Day14.part2() |> IO.inspect(label: "p2")
time_t3 = NaiveDateTime.utc_now
IO.puts("Time p1: " <> Integer.to_string(NaiveDateTime.diff(time_t2, time_t1, :millisecond))<> "ms")
IO.puts("Time p2: " <> Integer.to_string(NaiveDateTime.diff(time_t3, time_t2, :millisecond))<> "ms")

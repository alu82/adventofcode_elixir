defmodule Day18 do
  # Thanks to https://de.wukihow.com/wiki/Calculate-the-Area-of-a-Polygon

  def part1() do
    read_input() |> solve() |> IO.inspect()
  end

  def part2() do
    read_input2() |> solve() |> IO.inspect()
  end

  defp solve(input) do
    start = {0,0}

    circum = input |> Enum.map(fn {_dir, mtrs, _hex} -> mtrs end) |> Enum.sum()

    area = input
    |> Enum.reduce({[start], start},
      fn {{dr, dc}, mtrs, _hex}, {lagoon, {r, c}} ->
        next_pos = {r+dr*mtrs, c+dc*mtrs}
        next_lagoon = List.insert_at(lagoon, -1, next_pos)
        {next_lagoon, next_pos}
      end
    )
    |> elem(0)
    |> Stream.chunk_every(2,1, :discard) |> Enum.to_list()
    |> Enum.map(fn [{y1, x1}, {y2, x2}] -> x1*y2 - y1*x2 end)
    |> Enum.sum()

    round((circum+area)/2 + 1)
  end

  defp read_input() do
    dir_mapping = %{"U" => {-1,0}, "D" => {1,0}, "L" => {0,-1}, "R" => {0,1}}

    File.read(Path.dirname(__ENV__.file) <> "/day18.input")
    |> elem(1)
    |> String.split("\n", trim: true)
    |> Enum.map(fn line -> String.split(line, " ", trim: true) end)
    |> Enum.map(fn [dir, mtr, hex] -> {Map.get(dir_mapping, dir), String.to_integer(mtr), hex} end)
  end

  def read_input2() do
    dir_mapping = %{"3" => {-1,0}, "1" => {1,0}, "2" => {0,-1}, "0" => {0,1}}

    File.read(Path.dirname(__ENV__.file) <> "/day18.input")
    |> elem(1)
    |> String.split("\n", trim: true)
    |> Enum.map(fn line -> String.split(line, " ", trim: true) end)
    |> Enum.map(fn [_d, _m, hex] ->
      mtrs = String.to_integer(String.slice(hex, 2, 5), 16)
      dir = Map.get(dir_mapping, String.at(hex, -2))
      {dir, mtrs, hex}
      end
    )
  end

end

time_t1 = NaiveDateTime.utc_now
Day18.part1()
time_t2 = NaiveDateTime.utc_now
Day18.part2()
time_t3 = NaiveDateTime.utc_now
IO.puts("Time p1: " <> Integer.to_string(NaiveDateTime.diff(time_t2, time_t1, :millisecond))<> "ms")
IO.puts("Time p2: " <> Integer.to_string(NaiveDateTime.diff(time_t3, time_t2, :millisecond))<> "ms")

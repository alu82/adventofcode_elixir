defmodule Day00 do

  def part1() do
    solve()
  end

  def part2() do

  end

  defp solve() do
    read_input()
  end

  defp read_input() do
    File.read(Path.dirname(__ENV__.file) <> "/day00.input")
    |> elem(1)
    |> String.split("\n", trim: true)
    |> Enum.map(fn line -> line end)
  end

end

time_t1 = NaiveDateTime.utc_now
Day00.part1()
time_t2 = NaiveDateTime.utc_now
Day00.part2()
time_t3 = NaiveDateTime.utc_now
IO.puts("Time p1: " <> Integer.to_string(NaiveDateTime.diff(time_t2, time_t1, :millisecond))<> "ms")
IO.puts("Time p2: " <> Integer.to_string(NaiveDateTime.diff(time_t3, time_t2, :millisecond))<> "ms")

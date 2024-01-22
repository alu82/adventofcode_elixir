defmodule Day23 do

  def part1() do
    solve() |> IO.inspect()
  end

  def part2() do

  end

  defp solve() do
    grid = read_input()
    at = fn {r, c} -> grid |> Enum.at(r, []) |> Enum.at(c) end

    {s_r, s_c} = {0, 1}
    {t_r, t_c} = {length(grid)-1, -2}

    step(
      {}
      fn {todo, seen, distances} ->
        {todo, seen, distances}
      end
    )


    IO.inspect({s,e})


  end


  defp step(init, fun) do
    case fun.(init) do
      {:cont, value} -> step(value, fun)
      {:halt, result} -> result
    end
  end

  defp read_input() do
    File.read(Path.dirname(__ENV__.file) <> "/day23.input")
    |> elem(1)
    |> String.split("\n", trim: true)
    |> Enum.map(fn line -> line |> String.graphemes() end)
  end

end

time_t1 = NaiveDateTime.utc_now
Day23.part1()
time_t2 = NaiveDateTime.utc_now
Day23.part2()
time_t3 = NaiveDateTime.utc_now
IO.puts("Time p1: " <> Integer.to_string(NaiveDateTime.diff(time_t2, time_t1, :millisecond))<> "ms")
IO.puts("Time p2: " <> Integer.to_string(NaiveDateTime.diff(time_t3, time_t2, :millisecond))<> "ms")

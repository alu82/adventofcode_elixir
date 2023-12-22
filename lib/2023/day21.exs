defmodule Day21 do

  def part1() do
    walk(64) |> IO.inspect()
  end

  def part2() do
    walk(100) |> IO.inspect()
  end

  defp walk(steps) do
    garden = read_input()

    {sr, sc} = garden
    |> Enum.with_index()
    |> Enum.filter(fn {l, _i} -> Enum.member?(l, "S") end)
    |> Enum.flat_map(fn {l, r} ->
      l |> Enum.with_index() |> Enum.filter(fn {s, _c} -> s=="S" end) |> Enum.map(fn {_s, c} -> {r, c} end)
    end)
    |> hd()


    start = MapSet.new() |> MapSet.put({sr, sc})

    next(garden, start, steps, 0) |> Enum.count()

  end


  defp next(_garden, pos, steps, current) when steps==current do pos end
  defp next(garden, pos, steps, current) do

    max_r = length(garden)
    max_c = length(hd(garden))

    at = fn {r,c} ->
      nr = rem(r, max_r)
      nc = rem(c, max_c)
      garden |> Enum.at(nr) |> Enum.at(nc, [])
    end

    next_pos =
      pos
      |> Enum.flat_map(
      fn {r, c} ->
          [{0,1}, {1,0}, {0,-1}, {-1,0}]
          |> Enum.map(fn {dr, dc} -> {r+dr, c+dc} end)
          |> Enum.filter(fn {dr, dc} -> at.({dr, dc}) in [".", "S"] end)
      end
      )
      |> MapSet.new()

    next(garden, next_pos, steps, current+1)
  end


  defp read_input() do
    File.read(Path.dirname(__ENV__.file) <> "/day21.input")
    |> elem(1)
    |> String.split("\n", trim: true)
    |> Enum.map(fn line -> String.codepoints(line) end)
  end

end

time_t1 = NaiveDateTime.utc_now
Day21.part1()
time_t2 = NaiveDateTime.utc_now
Day21.part2()
time_t3 = NaiveDateTime.utc_now
IO.puts("Time p1: " <> Integer.to_string(NaiveDateTime.diff(time_t2, time_t1, :millisecond))<> "ms")
IO.puts("Time p2: " <> Integer.to_string(NaiveDateTime.diff(time_t3, time_t2, :millisecond))<> "ms")

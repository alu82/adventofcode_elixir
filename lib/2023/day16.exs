defmodule Day16 do

  def part1() do
    solve(read_input(), {0, 0, :right}) |> IO.inspect()
  end

  def part2() do
    layout = read_input()
    rows = length(layout)-1
    cols = length(List.first(layout, []))-1

    left = 0..rows |> Enum.map(fn r -> {r, 0, :right} end)
    right = 0..rows |> Enum.map(fn r -> {r, cols, :left} end)
    top = 0..cols |> Enum.map(fn c -> {0, c, :down} end)
    bottom = 0..cols |> Enum.map(fn c -> {rows, c, :up} end)
    starts = left ++ right ++ top ++ bottom

    starts |> Enum.map(fn beam -> solve(layout, beam) end) |> Enum.max() |> IO.inspect()
  end

  defp solve(layout, {row, col, dir}) do
    move_beam({row, col, dir}, at(layout, row, col), layout, MapSet.new()) |> Enum.map(fn {r,c,_d} -> {r,c} end) |> MapSet.new() |> MapSet.size()
  end

  defp move_beam({_row, _col, _direction}, nil, _layout, energized) do energized end
  defp move_beam({row, col, _direction}, _en, _layout, energized) when row<0 or col<0 do energized end

  defp move_beam({row, col, :right}, en, layout, energized) when en in [".", "-"] do
    cond do
      Enum.member?(energized, {row, col, :right}) -> energized
      true -> move_beam({row, col+1, :right}, at(layout, row, col+1), layout, MapSet.put(energized, {row, col, :right}))
    end
  end
  defp move_beam({row, col, :right}, en, layout, energized) when en in ["\\"] do
    cond do
      Enum.member?(energized, {row, col, :right}) -> energized
      true -> move_beam({row+1, col, :down}, at(layout, row+1, col), layout, MapSet.put(energized, {row, col, :right}))
    end
  end
  defp move_beam({row, col, :right}, en, layout, energized) when en in ["/"] do
    cond do
      Enum.member?(energized, {row, col, :right}) -> energized
      true -> move_beam({row-1, col, :up}, at(layout, row-1, col), layout, MapSet.put(energized, {row, col, :right}))
    end
  end
  defp move_beam({row, col, :right}, en, layout, energized) when en in ["|"] do
    cond do
      Enum.member?(energized, {row, col, :right}) -> energized
      true ->
        new_energized = move_beam({row-1, col, :up}, at(layout, row-1, col), layout, MapSet.put(energized, {row, col, :right}))
        move_beam({row+1, col, :down}, at(layout, row+1, col), layout, new_energized)
    end
  end

  defp move_beam({row, col, :left}, en, layout, energized) when en in [".", "-"] do
    cond do
      Enum.member?(energized, {row, col, :left}) -> energized
      true -> move_beam({row, col-1, :left}, at(layout, row, col-1), layout, MapSet.put(energized, {row, col, :left}))
    end
  end
  defp move_beam({row, col, :left}, en, layout, energized) when en in ["\\"] do
    cond do
      Enum.member?(energized, {row, col, :left}) -> energized
      true -> move_beam({row-1, col, :up}, at(layout, row-1, col), layout, MapSet.put(energized, {row, col, :left}))
    end
  end
  defp move_beam({row, col, :left}, en, layout, energized) when en in ["/"] do
    cond do
      Enum.member?(energized, {row, col, :left}) -> energized
      true -> move_beam({row+1, col, :down}, at(layout, row+1, col), layout, MapSet.put(energized, {row, col, :left}))
    end
  end
  defp move_beam({row, col, :left}, en, layout, energized) when en in ["|"] do
    cond do
      Enum.member?(energized, {row, col, :left}) -> energized
      true ->
        new_energized = move_beam({row-1, col, :up}, at(layout, row-1, col), layout, MapSet.put(energized, {row, col, :left}))
        move_beam({row+1, col, :down}, at(layout, row+1, col), layout, new_energized)
    end
  end

  defp move_beam({row, col, :up}, en, layout, energized) when en in [".", "|"] do
    cond do
      Enum.member?(energized, {row, col, :up}) -> energized
      true -> move_beam({row-1, col, :up}, at(layout, row-1, col), layout, MapSet.put(energized, {row, col, :up}))
    end
  end
  defp move_beam({row, col, :up}, en, layout, energized) when en in ["\\"] do
    cond do
      Enum.member?(energized, {row, col, :up}) -> energized
      true -> move_beam({row, col-1, :left}, at(layout, row, col-1), layout, MapSet.put(energized, {row, col, :up}))
    end
  end
  defp move_beam({row, col, :up}, en, layout, energized) when en in ["/"] do
    cond do
      Enum.member?(energized, {row, col, :up}) -> energized
      true -> move_beam({row, col+1, :right}, at(layout, row, col+1), layout, MapSet.put(energized, {row, col, :up}))
    end
  end
  defp move_beam({row, col, :up}, en, layout, energized) when en in ["-"] do
    cond do
      Enum.member?(energized, {row, col, :up}) -> energized
      true ->
        new_energized = move_beam({row, col+1, :right}, at(layout, row, col+1), layout, MapSet.put(energized, {row, col, :up}))
        move_beam({row, col-1, :left}, at(layout, row, col-1), layout, new_energized)
    end
  end

  defp move_beam({row, col, :down}, en, layout, energized) when en in [".", "|"] do
    cond do
      Enum.member?(energized, {row, col, :down}) -> energized
      true -> move_beam({row+1, col, :down}, at(layout, row+1, col), layout, MapSet.put(energized, {row, col, :down}))
    end
  end
  defp move_beam({row, col, :down}, en, layout, energized) when en in ["\\"] do
    cond do
      Enum.member?(energized, {row, col, :down}) -> energized
      true -> move_beam({row, col+1, :right}, at(layout, row, col+1), layout, MapSet.put(energized, {row, col, :down}))
    end
  end
  defp move_beam({row, col, :down}, en, layout, energized) when en in ["/"] do
    cond do
      Enum.member?(energized, {row, col, :down}) -> energized
      true -> move_beam({row, col-1, :left}, at(layout, row, col-1), layout, MapSet.put(energized, {row, col, :down}))
    end
  end
  defp move_beam({row, col, :down}, en, layout, energized) when en in ["-"] do
    cond do
      Enum.member?(energized, {row, col, :down}) -> energized
      true ->
        new_energized = move_beam({row, col+1, :right}, at(layout, row, col+1), layout, MapSet.put(energized, {row, col, :down}))
        move_beam({row, col-1, :left}, at(layout, row, col-1), layout, new_energized)
    end
  end

  defp at(layout, row, col) do layout |> Enum.at(row, []) |> Enum.at(col) end

  defp read_input() do
    File.read(Path.dirname(__ENV__.file) <> "/day16.input")
    |> elem(1)
    |> String.split("\n", trim: true)
    |> Enum.map(fn line -> String.codepoints(line) end)
  end

end

time_t1 = NaiveDateTime.utc_now
Day16.part1()
time_t2 = NaiveDateTime.utc_now
Day16.part2()
time_t3 = NaiveDateTime.utc_now
IO.puts("Time p1: " <> Integer.to_string(NaiveDateTime.diff(time_t2, time_t1, :millisecond))<> "ms")
IO.puts("Time p2: " <> Integer.to_string(NaiveDateTime.diff(time_t3, time_t2, :millisecond))<> "ms")

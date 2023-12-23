defmodule Day22 do

  def part1() do
    {grid, _fallen} = read_input() |> fall()
    grid |> Enum.reject(&is_supporting(&1, grid)) |> Enum.count() |> IO.inspect()
  end

  def part2() do
    {grid, _fallen} = read_input() |> fall()

    0..length(grid)-1
    |> Enum.reduce(
      0,
      fn idx, f_count ->
        f = grid |> List.pop_at(idx) |> elem(1) |> fall() |> elem(1)
        f_count + f
      end
    ) |> IO.inspect()
  end

  defp fall(grid) do
    grid
    |> Enum.sort_by(fn [start: [_x, _y, z], end: _e] -> z end)
    |> Enum.reduce(
      {[], 0},
      fn brick, {ggrid, fallen} ->
        fallen_brick = fall_down(brick, ggrid)
        new_fallen =
          cond do
            fallen_brick == brick -> fallen
            fallen_brick != brick -> fallen + 1
          end

        {List.insert_at(ggrid, -1, fallen_brick), new_fallen} end
    )
  end

  defp fall_down([start: [xs, ys, 1], end: [xe, ye, ze]], _grid)  do [start: [xs, ys, 1], end: [xe, ye, ze]] end
  defp fall_down(brick = [start: [xs, ys, zs], end: [xe, ye, ze]], grid) do
    supporting_bricks = grid |> Enum.filter(&supports(&1, brick))

    cond do
      Enum.count(supporting_bricks) > 0 -> brick
      Enum.count(supporting_bricks) == 0 -> fall_down([start: [xs, ys, zs-1], end: [xe, ye, ze-1]], grid)
    end
  end

  defp is_supporting(brick, grid) do
    supported_bricks = grid |> Enum.filter(&supports(brick, &1))

    cond do
      length(supported_bricks) == 0 -> false
      length(supported_bricks) > 0 ->
        supported_bricks
        |> Enum.map(fn b -> grid |> Enum.filter(&supports(&1, b)) end)
        |> Enum.map(&(Enum.count(&1)==1))
        |> Enum.any?()
    end
  end

  # does the first brick support the second one
  defp supports(b1=[start: _start, end: [_x1e, _y1e, z1e]], b2=[start: [_x2s, _y2s, z2s], end: _end]) do
    cond do
      z1e != z2s-1 -> false
      z1e == z2s-1 -> overlaps(b1, b2)
    end
  end

  defp overlaps([start: [x1s, y1s, _z1s], end: [x1e, y1e, _z1e]], [start: [x2s, y2s, _z2s], end: [x2e, y2e, _z2e]]) do
    (not Range.disjoint?(x1s..x1e, x2s..x2e)) and (not Range.disjoint?(y1s..y1e, y2s..y2e))
  end

  defp read_input() do
    File.read(Path.dirname(__ENV__.file) <> "/day22.input")
    |> elem(1)
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "~"))
    |> Enum.map(
      fn [s, e] ->
        c_start = s |> String.split(",") |> Enum.map(&String.to_integer/1)
        c_end = e |> String.split(",") |> Enum.map(&String.to_integer/1)
        [start: c_start, end: c_end]
      end
    )
  end

end

time_t1 = NaiveDateTime.utc_now
Day22.part1()
time_t2 = NaiveDateTime.utc_now
Day22.part2()
time_t3 = NaiveDateTime.utc_now
IO.puts("Time p1: " <> Integer.to_string(NaiveDateTime.diff(time_t2, time_t1, :millisecond))<> "ms")
IO.puts("Time p2: " <> Integer.to_string(NaiveDateTime.diff(time_t3, time_t2, :millisecond))<> "ms")

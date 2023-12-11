defmodule Day10 do

  @connectors %{
    "|" => [:north, :south],
    "-" => [:east, :west],
    "L" => [:north, :east],
    "J" => [:north, :west],
    "7" => [:south, :west],
    "F" => [:south, :east]
  }

  def part1() do
    map = read_input()

    start_pos =
      map |> Map.to_list() |> Enum.filter(fn {_pos, val} -> val == "S" end) |> List.first() |> elem(0)

    start_pipe = get_pipe(
      Map.get(map, move(start_pos, :north)),
      Map.get(map, move(start_pos, :east)),
      Map.get(map, move(start_pos, :south)),
      Map.get(map, move(start_pos, :west)))

    map = %{ map | start_pos => start_pipe}

    path = loop(map, [start_pos], nil)
    IO.inspect(path)
    IO.inspect(length(path)/2)

  end

  def part2() do
    map = read_input()

    start_pos =
      map |> Map.to_list() |> Enum.filter(fn {_pos, val} -> val == "S" end) |> List.first() |> elem(0)

    start_pipe = get_pipe(
      Map.get(map, move(start_pos, :north)),
      Map.get(map, move(start_pos, :east)),
      Map.get(map, move(start_pos, :south)),
      Map.get(map, move(start_pos, :west)))

    map = %{ map | start_pos => start_pipe}

    path = loop(map, [start_pos], nil)

    clean_map = map
    |> Enum.map(fn {pos, sign} ->
      cond do
        pos in path -> {pos, sign}
        true -> {pos, "."}
      end
    end)
    |> Enum.into(%{})

    clean_map
    |> Enum.map(&is_inner(clean_map, &1))
    |> Enum.sum()
    |> IO.inspect()
  end

  defp is_inner(_map, {_pos, sign}) when sign != "." do 0 end
  defp is_inner(map, {pos, "."}) do
    ray(map, [], pos, ".") |> walls_jumped(nil, nil) |> rem(2)
  end

  def walls_jumped([], _ctr, nil) do 0 end

  def walls_jumped(path, _ctr, "|") do
    {next, rem_path} = List.pop_at(path, 0)
    1 + walls_jumped(rem_path, nil, next)
  end

  def walls_jumped(path, ctr, "-") do
    {next, rem_path} = List.pop_at(path, 0)
    walls_jumped(rem_path, ctr, next)
  end

  def walls_jumped(path, _ctr, current) when current in ["L", "F"] do
    {next, rem_path} = List.pop_at(path, 0)
    walls_jumped(rem_path, current, next)
  end

  def walls_jumped(path, "L", "7") do
    {next, rem_path} = List.pop_at(path, 0)
    1 + walls_jumped(rem_path, nil, next)
  end

  def walls_jumped(path, "F", "J") do
    {next, rem_path} = List.pop_at(path, 0)
    1 + walls_jumped(rem_path, nil, next)
  end

  def walls_jumped(path, _ctr, _next) do
    {next, rem_path} = List.pop_at(path, 0)
    walls_jumped(rem_path, nil, next)
  end

  defp ray(_map, path, _pos, nil) do path end
  defp ray(map, path, current_pos, _sign) do
    next_pos = move(current_pos, :east)
    next_sign = Map.get(map, next_pos)
    ray(map, List.insert_at(path, -1, next_sign), next_pos, next_sign)
  end

  defp loop(map, path, prv_direction) do
    current_pos =  List.last(path)
    current_pipe = Map.get(map, current_pos)
    next_direction = get_move_direction(current_pipe, prv_direction)
    next_pos = move(current_pos, next_direction)

    cond do
      next_pos in path -> path
      true -> loop(map, List.insert_at(path, -1, next_pos), next_direction)
    end

  end

  defp move({row, col}, :north) do {row-1, col} end
  defp move({row, col}, :east) do {row, col+1} end
  defp move({row, col}, :south) do {row+1, col} end
  defp move({row, col}, :west) do {row, col-1} end

  defp get_pipe(north, _east, south, _west) when north in ["|", "7"] and south in ["|", "J"] do "|" end
  defp get_pipe(_north, east, _south, west) when east in ["-", "J"] and west in ["-", "F"] do "-" end
  defp get_pipe(north, east, _south, _west) when north in ["|", "7"] and east in ["-", "J"] do "L" end
  defp get_pipe(north, _east, _south, west) when north in ["|", "7"] and west in ["-", "F"] do "J" end
  defp get_pipe(_north, _east, south, west) when south in ["|", "J"] and west in ["-", "F"] do "7" end
  defp get_pipe(_north, east, south, _west) when east in ["-", "J", "7"] and south in ["|", "J"] do "F" end

  defp get_move_direction(current_pipe, prv_direction) do
    @connectors |> Map.get(current_pipe) |> Enum.reject(&(&1==back(prv_direction))) |> List.first()
  end

  defp back(:north) do :south end
  defp back(:east) do :west end
  defp back(:south) do :north end
  defp back(:west) do :east end
  defp back(nil) do nil end

  defp read_input() do
    File.read(Path.dirname(__ENV__.file) <> "/day10.input")
    |> elem(1)
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, row} ->
      line |> String.codepoints() |> Enum.with_index() |> Enum.map(fn {sign, col} -> {{row, col}, sign} end)
    end)
    |> Enum.reduce(%{}, fn {pos, sign}, acc -> Map.put(acc, pos, sign) end)
  end

end

time_t1 = NaiveDateTime.utc_now
Day10.part1()
time_t2 = NaiveDateTime.utc_now
Day10.part2()
time_t3 = NaiveDateTime.utc_now
IO.puts("Time p1: " <> Integer.to_string(NaiveDateTime.diff(time_t2, time_t1, :millisecond))<> "ms")
IO.puts("Time p2: " <> Integer.to_string(NaiveDateTime.diff(time_t3, time_t2, :millisecond))<> "ms")

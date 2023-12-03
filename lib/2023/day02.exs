defmodule Day02 do

  def part1() do
    read_input()
    |> Enum.map(fn g -> extract_game(g) end)
    |> Enum.filter(fn g -> is_valid_game(g) end)
    |> Enum.map(fn {id, _} -> id end)
    |> Enum.sum
    |> IO.puts
  end

  def part2() do
    read_input()
    |> Enum.map(fn g -> extract_game(g) end)
    |> Enum.map(fn g -> calc_power(g) end)
    |> Enum.map(fn {_, power} -> power end)
    |> Enum.sum
    |> IO.puts
  end

  defp calc_power({game_id, {red, green, blue}}) do
    {game_id, red*green*blue}
  end

  defp is_valid_game({_, {red, green, blue}}) do
    (red <= 12) and (green <= 13) and (blue <= 14)
  end

  defp extract_game(raw_game) do
    [game | [raw_subsets | _]] = String.split(raw_game, ":", trim: true)
    [_ | [game_id_str | _]] = String.split(game, " ", trim: true)
    {game_id, _} = Integer.parse(game_id_str)

    {_, maximums} = raw_subsets
      |> String.split([";", ","], trim: true)
      |> Enum.map_reduce(
        {0,0,0},
        fn t, {r,g,b} ->
          red = cube_count(t, "red")
          green = cube_count(t, "green")
          blue = cube_count(t, "blue")
          {t, {Enum.max([r, red]), Enum.max([g, green]), Enum.max([b, blue])}}
        end
      )

    {game_id, maximums}
  end

  defp cube_count(subset, color) do
    {count, _} = if String.contains?(subset, color) do
      Integer.parse(String.replace(subset, [" ", color], ""))
    else
      {0, nil}
    end
    count
  end


  defp read_input() do
    {:ok, input} = File.read(Path.dirname(__ENV__.file) <> "/day02.input")
    String.split(input, "\n", trim: true)
  end

end

Day02.part1()
Day02.part2()

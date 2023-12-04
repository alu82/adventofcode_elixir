defmodule Day04 do

  def part1() do
    read_input()
    |> Enum.map(&String.split(&1, ":", trim: true))
    |> Enum.map(&List.delete_at(&1, 0))
    |> Enum.map(fn [hd | _] -> String.split(hd, "|", trim: true) end)
    |> Enum.map(fn card ->
      winning = MapSet.new(String.split(Enum.at(card, 0), " ", trim: true))
      my = MapSet.new(String.split(Enum.at(card, 1), " ", trim: true))
      2**(MapSet.size(MapSet.intersection(winning, my))-1)
    end)
    |> Enum.filter(&(&1>0.5))
    |> Enum.sum()
    |> IO.inspect()
  end

  def part2() do
    input = read_input()

    input
    |> Enum.map(&String.split(&1, ":", trim: true))
    |> Enum.map(&List.delete_at(&1, 0))
    |> Enum.map(fn [hd | _] -> String.split(hd, "|", trim: true) end)
    |> Enum.map(fn card ->
      winning = MapSet.new(String.split(Enum.at(card, 0), " ", trim: true))
      my = MapSet.new(String.split(Enum.at(card, 1), " ", trim: true))
      MapSet.size(MapSet.intersection(winning, my))
    end)
    |> Enum.with_index(&({&2, &1}))
    |> Enum.reduce(List.duplicate(1, length(input)), &win_cards/2)
    |> Enum.sum()
    |> IO.inspect()
  end

  defp win_cards({idx, matching_numbers}, cards) when matching_numbers > 0 do
    inc_idx = MapSet.new(Enum.to_list((idx+1)..(idx+matching_numbers)))
    increment = Enum.at(cards, idx)

    cards
    |> Enum.with_index(&({&2, &1}))
    |> Enum.map(fn {idx, amount} ->
      cond do
        MapSet.member?(inc_idx, idx) -> amount + increment
        true -> amount
      end
    end)
  end

  defp win_cards({_, _}, cards) do
    cards
  end

  defp read_input() do
    {:ok, input} = File.read(Path.dirname(__ENV__.file) <> "/day04.input")
    String.split(input, "\n", trim: true)
  end

end

Day04.part1()
Day04.part2()

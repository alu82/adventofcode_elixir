defmodule Day07 do

  def part1() do
    read_input()
    |> Enum.map(fn l -> String.split(l, " ", trim: true) end)
    |> Enum.map(fn [h, b] ->
      {hand, _b} =
        hand_type(h) <> h
        |> String.replace("T", "B")
        |> String.replace("J", "C")
        |> String.replace("Q", "D")
        |> String.replace("K", "E")
        |> String.replace("A", "F")
        |> Integer.parse(16)
        {bid, _b} = Integer.parse(b)
        [hand, bid]
    end)
    |> Enum.sort_by(fn [hand, _bid] -> hand end, :asc)
    |> Enum.with_index(&({&2, &1}))
    |> Enum.map(fn {rank, [_hand, bid]} -> (rank+1)*bid end)
    |> Enum.sum()
    |> IO.inspect()

  end

  def part2() do
    read_input()
    |> Enum.map(fn l -> String.split(l, " ", trim: true) end)
    |> Enum.map(fn [h, b] ->
      {hand, _b} =
        hand_type_joker(h) <> h
        |> String.replace("T", "B")
        |> String.replace("J", "0")
        |> String.replace("Q", "D")
        |> String.replace("K", "E")
        |> String.replace("A", "F")
        |> Integer.parse(16)
        {bid, _b} = Integer.parse(b)
        [hand, bid]
    end)
    |> Enum.sort_by(fn [hand, _bid] -> hand end, :asc)
    |> Enum.with_index(&({&2, &1}))
    |> Enum.map(fn {rank, [_hand, bid]} -> (rank+1)*bid end)
    |> Enum.sum()
    |> IO.inspect()

  end

  def hand_type_joker(hand) when hand == "JJJJJ" do
    hand_type(hand)
  end

  def hand_type_joker(hand) do
    hand_list = String.codepoints(hand)

    {r_card, _count} = hand
    |> String.codepoints()
    |> Enum.reject(&(&1=="J"))
    |> Enum.map(fn card -> {card, Enum.count(hand_list, &(&1==card))} end)
    |> Enum.max_by(fn {_card, count} -> count end)

    hand_type(String.replace(hand, "J", r_card))
  end

  def hand_type(hand) do
    hand_list = String.codepoints(hand)
    card_dist = hand_list
    |> Enum.map(fn card -> Enum.count(hand_list, &(&1==card)) end)
    |> Enum.sort(:desc)

    case card_dist do
      [5,5,5,5,5] -> "9"
      [4,4,4,4,1] -> "8"
      [3,3,3,2,2] -> "7"
      [3,3,3,1,1] -> "6"
      [2,2,2,2,1] -> "5"
      [2,2,1,1,1] -> "4"
      [1,1,1,1,1] -> "3"
      _ -> "0"
    end
  end

  defp read_input() do
    {:ok, input} = File.read(Path.dirname(__ENV__.file) <> "/day07.input")
    String.split(input, "\n", trim: true)
  end

end

Day07.part1()
Day07.part2()

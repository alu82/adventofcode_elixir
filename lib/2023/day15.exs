defmodule Day15 do

  def part1() do
    solve() |> IO.inspect()
  end

  def part2() do
    boxes = Enum.reduce(0..255, %{}, fn box, boxes -> Map.put(boxes, box, []) end)

    read_input()
    |> Enum.reduce(boxes, fn step, acc -> place_lense(step, acc) end)
    |> Enum.map(&focus_power/1)
    |> Enum.sum()
    |> IO.inspect()

  end

  defp solve() do
    read_input()
    |> Enum.map(&String.to_charlist/1)
    |> Enum.map(&hash(&1, 0))
    |> Enum.sum()
  end

  defp focus_power({box, lenses}) do
    lenses |> Enum.with_index(1) |> Enum.map(fn {{_l, focal_len}, slot} -> (box+1)*slot*focal_len end) |> Enum.sum()
  end

  defp place_lense(step, boxes) do
    if String.contains?(step, "-") do
      [label | _] = String.split(step, "-")
      box = hash(String.to_charlist(label), 0)
      lense_list = Map.get(boxes, box)

      updated_lense_list = lense_list
      |> Enum.map(fn {l, v} ->
          if l==label do {l,0} else {l,v} end end)
      |> Enum.filter(fn {_l,v} -> v>0 end)

      %{boxes | box => updated_lense_list}

    else
      [label, focal_str] = String.split(step, "=")
      focal = String.to_integer(focal_str)
      box = hash(String.to_charlist(label), 0)
      lense_list = Map.get(boxes, box)

      {new_lense_list, updated} = lense_list
      |> Enum.map_reduce(false, fn {l,v}, upd ->
        if l==label do {{l,focal}, true} else {{l,v}, upd} end
      end)

      if updated do
        %{boxes | box => new_lense_list}
      else
        %{boxes | box => List.insert_at(new_lense_list, length(new_lense_list), {label, focal})}
      end
    end
  end

  defp hash([], current) do current end
  defp hash(c, current) do
    {next, next_list} = List.pop_at(c, 0)
    next_current = rem((current + next)*17, 256)
    hash(next_list, next_current)
  end

  defp read_input() do
    File.read(Path.dirname(__ENV__.file) <> "/day15.input")
    |> elem(1)
    |> String.split(",", trim: true)
  end

end

time_t1 = NaiveDateTime.utc_now
Day15.part1()
time_t2 = NaiveDateTime.utc_now
Day15.part2()
time_t3 = NaiveDateTime.utc_now
IO.puts("Time p1: " <> Integer.to_string(NaiveDateTime.diff(time_t2, time_t1, :millisecond))<> "ms")
IO.puts("Time p2: " <> Integer.to_string(NaiveDateTime.diff(time_t3, time_t2, :millisecond))<> "ms")

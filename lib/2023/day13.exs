defmodule Day13 do

  def part1() do
    sections = read_input()

    v_sum = sections
    |> Enum.map(fn section -> section |> Enum.reduce_while(nil, &get_reflections(&1, &2)) end)
    |> Enum.flat_map(&(MapSet.to_list(&1)))
    |> Enum.sum()


    h_sum = sections
    |> Enum.map(fn section ->
      section
      |> Enum.map(&(String.codepoints(&1)))
      |> Enum.zip()
      |> Enum.map(&(List.to_string(Tuple.to_list(&1))))
      |> Enum.reduce_while(nil, &get_reflections(&1, &2))
    end)
    |> Enum.flat_map(&(MapSet.to_list(&1)))
    |> Enum.map(&(100*&1))
    |> Enum.sum()

    IO.inspect(v_sum + h_sum)

  end

  def part2() do
    sections = read_input()

    sections_T = sections
    |> Enum.map(fn section ->
      section
      |> Enum.map(&(String.codepoints(&1)))
      |> Enum.zip()
      |> Enum.map(&(List.to_string(Tuple.to_list(&1))))
    end)

    v_sum = sections
    |> Enum.map(fn section ->
      rows = length(section)
      section
      |> Enum.flat_map(&get_reflections(&1))
      |> Enum.reduce(%{}, fn elem, counts ->  count_elems(elem, counts) end)
      |> Enum.filter(fn {_e, count} -> count==rows-1 end)
      |> Enum.map(&(elem(&1,0)))
      |> Enum.sum()
    end)
    |> Enum.sum()

    h_sum = sections_T
    |> Enum.map(fn section ->
      rows = length(section)
      section
      |> Enum.flat_map(&get_reflections(&1))
      |> Enum.reduce(%{}, fn elem, counts ->  count_elems(elem, counts) end)
      |> Enum.filter(fn {_e, count} -> count==rows-1 end)
      |> Enum.map(&(elem(&1,0)*100))
      |> Enum.sum()
    end)
    |> Enum.sum()

    IO.inspect(v_sum + h_sum)
  end

  def count_elems(elem, counts) do
    new_count = Map.get(counts, elem, 0) + 1
    Map.put(counts, elem, new_count)
  end

  defp get_reflections(pattern) do
    1..(String.length(pattern)-1) |> Enum.filter(&(is_reflection?(pattern, &1))) |> Enum.to_list()
  end

  defp get_reflections(pattern, reflections) do
    ref =
      if reflections == nil do
        MapSet.new(Enum.to_list(1..(String.length(pattern)-1) ))
      else
        reflections
      end

    new_reflections = ref |> Enum.filter(&(is_reflection?(pattern, &1))) |> MapSet.new()

    cond do
      MapSet.size(new_reflections) > 0 -> {:cont, new_reflections}
      MapSet.size(new_reflections) == 0 -> {:halt, new_reflections}
    end

  end

  defp is_reflection?(pattern, left) do
    {l, r} = String.split_at(pattern, left)
    l_rev = String.reverse(l)
    cond do
      String.length(l_rev) >= String.length(r) -> String.starts_with?(l_rev, r)
      true -> String.starts_with?(r, l_rev)
    end
  end

  defp read_input() do
    File.read(Path.dirname(__ENV__.file) <> "/day13.input")
    |> elem(1)
    |> String.split("\n\n", trim: true)
    |> Enum.map(fn pattern -> String.split(pattern, "\n", trim: true) end)
  end

end

time_t1 = NaiveDateTime.utc_now
Day13.part1()
time_t2 = NaiveDateTime.utc_now
Day13.part2()
time_t3 = NaiveDateTime.utc_now
IO.puts("Time p1: " <> Integer.to_string(NaiveDateTime.diff(time_t2, time_t1, :millisecond))<> "ms")
IO.puts("Time p2: " <> Integer.to_string(NaiveDateTime.diff(time_t3, time_t2, :millisecond))<> "ms")

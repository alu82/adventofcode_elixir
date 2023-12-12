defmodule Day12 do

  def part1() do
    read_input()
    |> Enum.map_reduce(%{}, fn {springs, groups}, cache -> possible_arrangements(springs, groups, String.at(springs, 0), cache) end)
    |> elem(0)
    |> Enum.sum()
    |> IO.inspect()
  end

  def part2() do
    read_input()
    |> Enum.map(&unfold/1)
    |> Enum.map_reduce(%{}, fn {springs, groups}, cache -> possible_arrangements(springs, groups, String.at(springs, 0), cache) end)
    |> elem(0)
    |> Enum.sum()
    |> IO.inspect()
  end

  defp unfold({springs, groups}) do
    unfolded_springs = springs <> "?" <> springs <> "?" <> springs <> "?" <> springs <> "?" <> springs
    unfolded_groups = groups ++ groups ++ groups ++ groups ++ groups
    {unfolded_springs, unfolded_groups}
  end

  defp possible_arrangements("", groups, _current, cache) do
    cond do
      length(groups) == 0 -> {1, cache}
      length(groups) > 0 -> {0, cache}
    end
  end

  defp possible_arrangements(springs, [], _current, cache) do
    cond do
      String.contains?(springs, "#") -> {0, cache}
      true -> {1, cache}
    end
  end

  defp possible_arrangements(springs, groups, ".", cache) do
    cache_key = {springs, groups}
    cached_value = Map.get(cache, cache_key)

    if cached_value == nil do
      springs = String.trim_leading(springs, ".")
      next_current = String.at(springs, 0)
      {result, updated_cache} = possible_arrangements(springs, groups, next_current, cache)
      {result, Map.put(updated_cache, cache_key, result)}
    else
      {cached_value, cache}
    end
  end

  defp possible_arrangements(springs, groups, "#", cache) do
    cache_key = {springs, groups}
    cached_value = Map.get(cache, cache_key)

    if cached_value == nil do
      current_group = List.first(groups)

      # check for invalid states
      slice = String.slice(springs, 0, current_group)
      next_current = String.at(springs, current_group)

      invalid = String.contains?(slice, ".") or String.length(slice) < current_group or next_current=="#"

      if invalid do
        {0, Map.put(cache, cache_key, 0)}
      else
        next_springs = String.slice(springs, current_group+1, 1000)
        {result, updated_cache} = possible_arrangements(next_springs, List.delete_at(groups, 0), String.at(next_springs, 0), cache)
        {result, Map.put(updated_cache, cache_key, result)}
      end

    else
      {cached_value, cache}
    end

  end

  defp possible_arrangements(springs, groups, "?", cache) do
    cache_key = {springs, groups}
    cached_value = Map.get(cache, cache_key)

    if cached_value == nil do
      next_springs = String.slice(springs, 1, 1000)
      {result_1, updated_cache_tmp} = possible_arrangements("#"<>next_springs, groups, "#", cache)
      {result_2, updated_cache} = possible_arrangements(next_springs, groups, String.at(next_springs, 0), updated_cache_tmp)
      result = result_1+result_2
      {result, Map.put(updated_cache, cache_key, result)}
    else
      {cached_value, cache}
    end
  end

  defp read_input() do
    File.read(Path.dirname(__ENV__.file) <> "/day12.input")
    |> elem(1)
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [springs, pattern] = String.split(line, " ",  trim: true)
      counts = pattern |> String.split(",") |> Enum.map(&(Integer.parse(&1) |> elem(0)))
      {springs, counts}
    end)
  end

end

time_t1 = NaiveDateTime.utc_now
Day12.part1()
time_t2 = NaiveDateTime.utc_now
Day12.part2()
time_t3 = NaiveDateTime.utc_now
IO.puts("Time p1: " <> Integer.to_string(NaiveDateTime.diff(time_t2, time_t1, :millisecond))<> "ms")
IO.puts("Time p2: " <> Integer.to_string(NaiveDateTime.diff(time_t3, time_t2, :millisecond))<> "ms")

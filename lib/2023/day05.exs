defmodule Day05 do

  @chapters [
    :seed_to_soil,
    :soil_to_fertilizer,
    :fertilizer_to_water,
    :water_to_light,
    :light_to_temperature,
    :temperature_to_humidity,
    :humidity_to_location
  ]

  def part1() do

    {almanac, _, _} = read_input()
    |> Enum.map(fn line -> if String.ends_with?(line, "map:") do :next else line end end)
    |> Enum.reduce({%{}, @chapters, :seeds}, &read_alamanac/2)

    almanac
    |> Map.get(:seeds)
    |> Enum.map(&resolve_mapping(&1, almanac, @chapters))
    |> Enum.min
    |> IO.inspect

  end

  def part2() do

    {almanac, _, _} = read_input()
    |> Enum.map(fn line -> if String.ends_with?(line, "map:") do :next else line end end)
    |> Enum.reduce({%{}, @chapters, :seeds}, &read_alamanac/2)

    start_seeds = almanac
    |> Map.get(:seeds)
    |> Enum.chunk_every(2)
    |> Enum.map(fn [s,r] -> {s,r} end)

    max = start_seeds
    |> Enum.map(fn {s,r} -> s+r-1 end)
    |> Enum.max()

    # {55,13}

    @chapters
    |> Enum.reduce(start_seeds, &transform_ranges(almanac, &1, &2, max))
    |> Enum.map(fn {s, _r} -> s end)
    |> Enum.min
    |> IO.inspect

  end

  def transform_ranges(almanac, chapter, acc, max) do
    acc
    |> Enum.flat_map(fn {start, range} ->
      almanac
      |> Map.get(chapter)
      |> insert_min_rule()
      |> insert_max_rule(max)
      |> Enum.map(fn {t, i, r} ->  {{t, i, r}, {Enum.max([start, i]), Enum.min([start+range-1, i+r-1])}} end)
      |> Enum.filter(fn {_, {s,e}} -> e>=s end)
      |> Enum.map(fn {{t, i, _r}, {s,e}} -> {t+(s-i) ,e-s+1} end)
    end)
  end

  defp insert_min_rule(rules) do
    case Enum.min_by(rules, fn {target, _input, _range} -> target end) do
      0 -> rules
      {t, _i, _r} -> MapSet.put(rules, {0,0,t})
    end
  end

  defp insert_max_rule(rules, max) do
    {t, _i, r} = Enum.max_by(rules, fn {target, _input, _range} -> target end)
    cond do
      max < t+r -> rules
      true -> MapSet.put(rules, {t+r,t+r,max})
    end
  end

  defp read_alamanac(:next, {almanac, chapters, _current}) do
    {next_current, next_chapters} = List.pop_at(chapters, 0)
    next_almanac = Map.put(almanac, next_current, MapSet.new())
    {next_almanac, next_chapters, next_current}
  end

  defp read_alamanac(line, {almanac, chapters, :seeds}) do
    [_title | seeds] = String.split(line, " ", trim: true)
    new_almanac = Map.put(almanac, :seeds, str_to_int(seeds))
    {new_almanac, chapters, :seeds}
  end

  defp read_alamanac(line, {almanac, chapters, current}) do
    [dest, source, len] = str_to_int(String.split(line, " ", trim: true))

    next_almanac = %{
      almanac |
      current => MapSet.put(Map.get(almanac, current), {dest, source, len})
    }

    {next_almanac, chapters, current}
  end

  defp str_to_int(str_list) do
    str_list
    |> Enum.map(&Integer.parse/1)
    |> Enum.map(fn {n, _base} -> n end)
  end

  defp resolve_mapping(source, _almanac, []) do
    source
  end

  defp resolve_mapping(source, almanac, chapters) do
    {chapter, rem_chapters} = List.pop_at(chapters, 0)

    map = almanac
    |> Map.get(chapter)
    |> Enum.filter(fn {_d, s, l} -> source in s..(s+l-1) end)
    |> List.first

    dest = case map do
      nil -> source
      {d, s, _l} -> source+d-s
    end

    resolve_mapping(dest, almanac, rem_chapters)
  end

  defp read_input() do
    {:ok, input} = File.read(Path.dirname(__ENV__.file) <> "/day05.input")
    String.split(input, "\n", trim: true)
  end

end

Day05.part1()
Day05.part2()

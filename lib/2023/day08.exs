defmodule Day08 do

  defp read_map(input) do
    input
    |> Enum.with_index(&({&2, &1}))
    |> Enum.reduce(%{}, fn {idx, elem}, acc ->
      parse_document(idx, elem, acc)
    end)
  end

  defp parse_document(idx, elem, _acc) when idx==0 do
    %{:directions => elem |> String.codepoints() |> Enum.map(&(String.to_atom(&1)))}
  end

  defp parse_document(idx, elem, acc) when idx>0 do
    Map.put(acc, String.slice(elem, 0..2), [L: String.slice(elem, 7..9), R: String.slice(elem, 12..14)])
  end

  defp navigate(_map, _from, _to, steps, true) do steps end
  defp navigate(map, from, to, steps, false) do
    directions = Map.get(map, :directions)
    direction = Enum.at(directions, rem(steps,length(directions)))
    next_from = Keyword.get(Map.get(map, from), direction)
    navigate(map, next_from, to, steps+1, Enum.member?(to, next_from))
  end

  defp get_ghost_start_end(map) do
    map
    |> Map.keys()
    |> Enum.reduce([MapSet.new([]), MapSet.new([])], fn node, [start_nodes, end_nodes] ->
      cond do
        node == :directions -> [start_nodes, end_nodes]
        String.ends_with?(node, "A") -> [MapSet.put(start_nodes, node), end_nodes]
        String.ends_with?(node, "Z") -> [start_nodes, MapSet.put(end_nodes, node)]
        true -> [start_nodes, end_nodes]
      end
    end)

  end

  defp lcm(a, nil, _rest) do a end
  defp lcm(a, b, rest) do
    {next_b, next_rest} = List.pop_at(rest, 0)
    lcm(Math.lcm(a, b), next_b, next_rest)
  end

  def part1() do
    read_input()
    |> read_map()
    |> navigate("AAA", ["ZZZ"],0, false)
    |> IO.inspect()
  end

  def part2() do
    map = read_input() |> read_map()
    [start_nodes, end_nodes] = get_ghost_start_end(map)
    paths = start_nodes |> Enum.map(&navigate(map, &1, end_nodes, 0, false))
    lcm(1,1, paths) |> IO.inspect()
  end

  defp read_input() do
    {:ok, input} = File.read(Path.dirname(__ENV__.file) <> "/day08.input")
    String.split(input, "\n", trim: true)
  end

end

time_t1 = NaiveDateTime.utc_now
Day08.part1()
time_t2 = NaiveDateTime.utc_now
Day08.part2()
time_t3 = NaiveDateTime.utc_now
IO.puts("Time p1: " <> Integer.to_string(NaiveDateTime.diff(time_t2, time_t1, :millisecond))<> "ms")
IO.puts("Time p2: " <> Integer.to_string(NaiveDateTime.diff(time_t3, time_t2, :millisecond))<> "ms")

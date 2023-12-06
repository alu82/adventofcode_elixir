defmodule Day06 do

  # @races1 [{7,9}, {15,40}, {30,200}]
  @races1 [{56,499}, {97,2210}, {77,1097}, {93,1440}]

  def part1() do
    @races1
    |> Enum.map(fn {duration, record} ->
      Enum.to_list(1..duration)
      |> Enum.map(&(&1*(duration-&1)))
      |> Enum.filter(&(&1>record))
      |> length()
    end)
    |> Enum.reduce(1, &(&1*&2))
    |> IO.puts

  end

  def part2() do #could be solved with part1, this approach saves a couple of iterations
    # {duration, record} = {71530, 940200}
    {duration, record} = {56977793, 499221010971440}

    1..duration
    |> Enum.to_list
    |> Enum.reduce_while(nil, fn p, _acc ->
      cond do
        p*(duration-p) > record -> {:halt, duration-2*p+1}
        true -> {:cont, nil}
      end
    end)
    |> IO.inspect()
  end

end

Day06.part1()
Day06.part2()

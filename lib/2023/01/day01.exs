defmodule Day01 do

  def part1() do
    IO.puts(read_input())
  end

  def part2() do

  end

  defp read_input() do
    input_path = Path.dirname(__ENV__.file) <> "/input"
    {:ok, input} = input_path |> File.read()
    input
    |> String.split("\n", trim: true)
  end

end

Day01.part1()
Day01.part2()

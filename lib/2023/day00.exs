defmodule Day00 do

  def part1() do
    read_input()
  end

  def part2() do

  end

  defp read_input() do
    {:ok, input} = File.read(Path.dirname(__ENV__.file) <> "/day00.input")
    String.split(input, "\n", trim: true)
  end

end

Day00.part1()
Day00.part2()

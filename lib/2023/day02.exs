defmodule Day02 do

  def part1() do
    read_input()
  end

  def part2() do

  end


  defp read_input() do
    {:ok, input} = File.read(Path.dirname(__ENV__.file) <> "/day02.input")
    String.split(input, "\n", trim: true)
  end

end

Day02.part1()
Day02.part2()

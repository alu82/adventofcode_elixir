defmodule Day01 do

  def part1() do
    read_input()
    |> Enum.map(fn l -> get_calibration_value(l) end)
    |> Enum.sum
    |> IO.puts
  end

  def part2() do
    read_input()
    |> Enum.map(fn l -> map_words_to_numbers(l) end)
    |> Enum.map(fn l -> get_calibration_value(l) end)
    |> Enum.sum
    |> IO.puts
  end

  defp get_calibration_value(amended_value) do
    all_ints = amended_value
      |> String.codepoints()
      |> Enum.filter(fn c ->
        case Integer.parse(c) do
          {v, _} -> v
          _ -> nil
        end
      end)

    {value, _} = Integer.parse(Enum.at(all_ints,0) <> Enum.at(all_ints,-1))
    value
  end

  def map_words_to_numbers(amended_value) do
    amended_value
    |> String.replace("one", "one1one")
    |> String.replace("two", "two2two")
    |> String.replace("three", "three3three")
    |> String.replace("four", "four4four")
    |> String.replace("five", "five5five")
    |> String.replace("six", "six6six")
    |> String.replace("seven", "seven7seven")
    |> String.replace("eight", "eight8eight")
    |> String.replace("nine", "nine9nine")
  end

  defp read_input() do
    {:ok, input} = File.read(Path.dirname(__ENV__.file) <> "/input")
    String.split(input, "\n", trim: true)
  end

end

Day01.part1()
Day01.part2()

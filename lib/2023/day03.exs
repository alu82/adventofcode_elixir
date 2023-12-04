defmodule Day03 do

  def part1() do

    input = read_input()

    board = input
    |> Enum.map(&String.codepoints/1)
    |> Enum.with_index(&({&2, &1})) # iterate over lines
    |> Enum.reduce(%{}, &read_board/2)

    {row_nr, _} = Enum.max_by(Map.keys(board), fn {row, _} -> row end)
    {_, col_nr} = Enum.max_by(Map.keys(board), fn {_, col} -> col end)

    valid = input
    |> Enum.map(&String.codepoints/1)
    |> Enum.with_index(&({&2, &1}))
    |> Enum.reduce(MapSet.new([]), &get_valid/2)

    collect_numbers(board, valid, {0,0}, {row_nr, col_nr}, "", false, [])
    |> Enum.filter(&(&1 != nil))
    |> Enum.sum
    |> IO.puts

  end

  def part2() do
    input = read_input()

    board = input
    |> Enum.map(&String.codepoints/1)
    |> Enum.with_index(&({&2, &1})) # iterate over lines
    |> Enum.reduce(%{}, &read_board/2)

    input
    |> Enum.map(&String.codepoints/1)
    |> Enum.with_index(&({&2, &1}))
    |> Enum.map(&get_valid_gear(&1, board))
    |> Enum.sum
    |> IO.puts

  end


  defp collect_numbers(board, valid_pos, {row, col}, {last_row, last_col}, buffer, is_valid, valid_numbers) do

    {n_buffer, n_is_valid, valid_number} =
      case Map.get(board, {row, col}) do
        number when number in ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"] ->
          next_buffer = buffer <> number
          next_is_valid = is_valid or ({row, col} in valid_pos)
          {next_buffer, next_is_valid, nil}
        _ when is_valid ->
          {number, _} = Integer.parse(buffer)
          {"", false, number}
        _ ->
          {"", false, nil}
      end

    cond do
      col <= last_col -> collect_numbers(board, valid_pos, {row, col+1}, {last_row, last_col}, n_buffer, n_is_valid, [valid_number | valid_numbers])
      row <= last_row -> collect_numbers(board, valid_pos, {row+1, 0}, {last_row, last_col}, "", false, [valid_number | valid_numbers])
      true -> valid_numbers
    end

  end

  defp read_board({row, line}, board) do
    line
    |> Enum.with_index(&({&2, &1}))
    |> Enum.reduce(board, fn {col, char}, board -> Map.put_new(board, {row, col}, char) end)
  end

  defp get_valid({row, line}, state) do
    line
    |> Enum.with_index(&({&2, &1}))
    |> Enum.reduce(state, &update_state(&2, &1, row))
  end

  defp update_state(state, {_, "."}, _) do
    state
  end

  defp update_state(state, {_, number}, _) when number in ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"] do
    state
  end

  defp update_state(state, {col, _}, row) do
    valid = MapSet.new([
      {row-1, col-1}, {row-1, col}, {row-1, col+1},
      {row, col-1}, {row, col}, {row, col+1},
      {row+1, col-1}, {row+1, col}, {row+1, col+1}
    ])
    MapSet.union(state, valid)
  end

  defp get_valid_gear({row, line}, board) do
    line
    |> Enum.with_index(&({&2, &1}))
    |> Enum.map(&update_state_gear(&1, row, board))
    |> Enum.sum
  end

  defp update_state_gear({col, "*"}, row, board) do
    adup =
      if Map.get(board, {row-1, col}) in ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"] do
        MapSet.new([{row-1, col}])
      else
        MapSet.new([{row-1, col-1}, {row-1, col}, {row-1, col+1}])
      end

    addown =
      if Map.get(board, {row+1, col}) in ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"] do
        MapSet.new([{row+1, col}])
      else
        MapSet.new([{row+1, col-1}, {row+1, col}, {row+1, col+1}])
      end

    adup
    |> MapSet.union(MapSet.new([{row, col-1}, {row, col+1}]))
    |> MapSet.union(addown)
    |> Enum.map(&get_number(board, &1, "start"))
    |> Enum.filter(&(&1 != ""))
    |> Enum.map(&Integer.parse/1)
    |> Enum.map(fn {n, _} -> n end)
    |> Enum.concat([-1])
    |> Enum.with_index(&({&2, &1}))
    |> Enum.reduce(1, fn {idx, value}, ratio ->
        cond do
          idx == 0 and value != -1 -> value
          idx == 1 and value != -1 -> ratio * value
          idx == 2 and value == -1 -> ratio
          true -> 0
        end
      end)
  end

  defp update_state_gear({_, _}, _, _) do
    0
  end

  defp get_number(board, {row, col}, "start") do
    case Map.get(board, {row, col}) do
      n when n in ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"] ->
        get_number(board, {row, col-1}, "left") <> n <> get_number(board, {row, col+1}, "right")
      _ ->
        ""
    end
  end

  defp get_number(board, {row, col}, "left") do
    case Map.get(board, {row, col}) do
      n when n in ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"] ->
        get_number(board, {row, col-1}, "left") <> n
      _ ->
        ""
    end
  end

  defp get_number(board, {row, col}, "right") do
    case Map.get(board, {row, col}) do
      n when n in ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"] ->
        n <> get_number(board, {row, col+1}, "right")
      _ ->
        ""
    end
  end





  defp read_input() do
    {:ok, input} = File.read(Path.dirname(__ENV__.file) <> "/day03.input")
    String.split(input, "\n", trim: true)
  end

end

Day03.part1()
Day03.part2()

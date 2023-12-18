defmodule Day17 do
  # Learnings (see function call of step)
  # > for the todo queue, take a heap structure
  # > for seen take a MapSet (not a map, the access to keys get slowly when increasing)
  # > the seen stores everything that is necessary for the state of the node. This might be row and col, but also other data incoming direction, ...
  # > therefore create a distance datastructure where only the result are stored (no reading operations - only at the end)
  # > here we have no end condition: the distance to every node is calculated. In this example we might have several end nodes (depending on the state)

  def part1() do
    solve(1,3) |> IO.inspect()

  end

  def part2() do
    solve(4,10) |> IO.inspect()
  end

  defp solve(min_len, max_len) do
    grid = read_input()
    m_row = length(grid)
    m_col = length(hd(grid))

    at = fn {r, c} -> grid |> Enum.at(r, []) |> Enum.at(c) end

    step(
      {Heap.min() |> Heap.push({0,0,0,-1,-1}), MapSet.new(), MapSet.new()},
      fn {todo, seen, distances} ->
        if Heap.size(todo)==0 do
          result = distances
          |> Enum.filter(fn {_dist, r, c, _d, dl} -> (r==m_row-1 and c==m_col-1) and (dl>=min_len and dl<=max_len) end)
          |> Enum.min_by(fn {dist, _r, _c, _d, _dl} -> dist end)
          |> elem(0)
          {:halt, result}
        else

          {this_dist = {dist, row, col, dir, dir_len}, tmp_todo} = Heap.split(todo)
          this = {row, col, dir, dir_len}

          cond do
            Enum.member?(seen, this) -> {:cont, {tmp_todo, seen, distances}}
            true ->
              new_seen = MapSet.put(seen, this)
              new_distances = MapSet.put(distances, this_dist)
              next_todo =
                [{0,1}, {1,0}, {0,-1}, {-1,0}]
                |> Enum.with_index()
                |> Enum.reduce(
                  tmp_todo,
                  fn {{dr, dc}, ndir}, ntodo ->
                    {nr, nc} = {row + dr, col + dc}
                    {ndir, ndir_len, turn} =
                      cond do
                        dir == -1 -> {ndir, 1, false}
                        dir == ndir -> {dir, dir_len+1, false}
                        dir != ndir -> {ndir, 1, true}
                      end

                    valid_index = (0<=nr and nr<m_row) and (0<=nc and nc<m_col)
                    # valid_length = min_len<=ndir_len and ndir_len<=max_len
                    valid_length = ndir_len<=max_len and ((turn and dir_len>=min_len) or (not turn))
                    valid_dir = rem((ndir + 2),4)!=dir

                    cond do
                      valid_index and valid_length and valid_dir -> Heap.push(ntodo, {dist+at.({nr, nc}), nr, nc, ndir, ndir_len})
                      true -> ntodo
                    end
                  end
                )
              {:cont, {next_todo, new_seen, new_distances}}
          end
        end
      end
    )
  end

  defp step(init, fun) do
    case fun.(init) do
      {:cont, value} -> step(value, fun)
      {:halt, result} -> result
    end
  end

  defp read_input() do
    File.read(Path.dirname(__ENV__.file) <> "/day17.input")
    |> elem(1)
    |> String.split("\n", trim: true)
    |> Enum.map(fn line -> line |> String.graphemes() |> Enum.map(&String.to_integer/1) end)
  end

end

time_t1 = NaiveDateTime.utc_now
Day17.part1()
time_t2 = NaiveDateTime.utc_now
Day17.part2()
time_t3 = NaiveDateTime.utc_now
IO.puts("Time p1: " <> Integer.to_string(NaiveDateTime.diff(time_t2, time_t1, :millisecond))<> "ms")
IO.puts("Time p2: " <> Integer.to_string(NaiveDateTime.diff(time_t3, time_t2, :millisecond))<> "ms")

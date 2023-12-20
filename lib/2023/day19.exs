defmodule Day19 do

  def part1() do
    sum_accepted() |> IO.inspect()
  end

  def part2() do
    combinations() |> IO.inspect()
  end

  defp combinations() do

    {workflows, _parts} = read_input()

    step(
      {[["in", 0, 4001, 0, 4001, 0, 4001, 0, 4001]], 0},
      fn {todos, combinations} ->
        cond do
          todos == [] -> {:halt, {todos, combinations}}
          true ->
            [next | todo] = todos
            [name, xl, xh, ml, mh, al, ah, sl, sh] = next
            cond do
              xl>xh or ml>mh or al>ah or sl>sh -> {:cont, {todo, combinations}}
              name =="R" -> {:cont, {todo, combinations}}
              name == "A" -> {:cont, {todo, combinations + (xh-xl-1)*(mh-ml-1)*(ah-al-1)*(sh-sl-1)}}
              true ->
                next_todo =
                  workflows
                  |> Map.get(name)
                  |> Enum.map_reduce(
                    [xl, xh, ml, mh, al, ah, sl, sh],
                    fn rule, tmp_ranges = [xll, xhh, mll, mhh, all, ahh, sll, shh] ->
                      case rule do
                        [to] -> {[to, xll, xhh, mll, mhh, all, ahh, sll, shh], tmp_ranges}
                        [cat, op, val, to] -> {
                          [to | update_ranges([xll, xhh, mll, mhh, all, ahh, sll, shh], cat, op, val)],
                          update_ranges_rev(tmp_ranges, cat, op, val)
                        }
                      end
                    end
                  )
                  |> elem(0)
                  |> Enum.reduce(todo, fn ntodo, ttodo -> [ntodo | ttodo] end)
                {:cont, {next_todo, combinations}}
            end
        end
      end
    )
  end

  defp update_ranges([xl, xh, ml, mh, al, ah, sl, sh], cat, op, val) do
    case {cat, op} do
      {:x, ">"} -> [max(xl, val), xh, ml, mh, al, ah, sl, sh]
      {:x, "<"} -> [xl, min(xh, val), ml, mh, al, ah, sl, sh]
      {:m, ">"} -> [xl, xh, max(ml, val), mh, al, ah, sl, sh]
      {:m, "<"} -> [xl, xh, ml, min(mh, val), al, ah, sl, sh]
      {:a, ">"} -> [xl, xh, ml, mh, max(al, val), ah, sl, sh]
      {:a, "<"} -> [xl, xh, ml, mh, al, min(ah, val), sl, sh]
      {:s, ">"} -> [xl, xh, ml, mh, al, ah, max(sl, val), sh]
      {:s, "<"} -> [xl, xh, ml, mh, al, ah, sl, min(sh, val)]
    end
  end

  defp update_ranges_rev([xl, xh, ml, mh, al, ah, sl, sh], cat, op, val) do
    case op do
      ">" -> update_ranges([xl, xh, ml, mh, al, ah, sl, sh], cat, "<", val+1)
      "<" -> update_ranges([xl, xh, ml, mh, al, ah, sl, sh], cat, ">", val-1)
    end
  end

  defp step(init, fun) do
    case fun.(init) do
      {:cont, value} -> step(value, fun)
      {:halt, result} -> result |> elem(1)
    end
  end

  defp sum_accepted() do
    {workflows, parts} = read_input()
    parts |> Enum.filter(&is_accepted(&1, Map.get(workflows, "in"), workflows)) |> Enum.flat_map(&(&1)) |> Enum.sum()
  end

  defp is_accepted(_part, [["A"]], _workflows) do true end
  defp is_accepted(_part, [["R"]], _workflows) do false end
  defp is_accepted(part, [[to]], workflows) do is_accepted(part, Map.get(workflows, to), workflows) end
  defp is_accepted(part, [[cat, op, value, to] | rules], workflows) do
    case eval_rule(part, [cat, op, value]) do
      false -> is_accepted(part, rules, workflows)
      true ->
        case to do
          "A" -> true
          "R" -> false
          target -> is_accepted(part, Map.get(workflows, target), workflows)
        end
    end
  end

  defp eval_rule(part, [cat, ">", value]) do get_part_value(part, cat) > value end
  defp eval_rule(part, [cat, "<", value]) do get_part_value(part, cat) < value end
  defp get_part_value([x,m,a,s], cat) do
    case cat do
      :x -> x
      :m -> m
      :a -> a
      :s -> s
    end
  end

  defp read_input() do
    File.read(Path.dirname(__ENV__.file) <> "/day19.input")
    |> elem(1)
    |> String.split("\n", trim: true)
    |> Enum.reduce(
      {%{}, []},
      fn line, {workflows, parts} ->
        cond do
          String.starts_with?(line, "{") ->
            part =
              line |> String.slice(1..-2) |> String.split(",")
              |> Enum.reduce(
                [],
                fn raw, part ->
                  [_cat, value] = String.split(raw, "=")
                  List.insert_at(part, -1, String.to_integer(value))
                end
              )
            {workflows, List.insert_at(parts, -1, part)}
          true ->
            [name, raw_rules] = line |> String.slice(0..-2) |> String.split("{")
            rules = raw_rules
              |> String.split(",")
              |> Enum.map(&String.split(&1, ":"))
              |> Enum.reduce(
                [],
                fn raw, rls ->
                  case raw do
                    [cat] -> rls |> List.insert_at(-1, [cat])
                    [con, cat] ->
                      rl = [
                        con |> String.at(0) |> String.to_atom(),
                        con |> String.at(1),
                        con |> String.slice(2..-1) |> String.to_integer(),
                        cat
                      ]
                      rls |> List.insert_at(-1, rl)
                    end
                end
              )
            {Map.put(workflows, name, rules), parts}
        end
      end
    )
  end
end

time_t1 = NaiveDateTime.utc_now
Day19.part1()
time_t2 = NaiveDateTime.utc_now
Day19.part2()
time_t3 = NaiveDateTime.utc_now
IO.puts("Time p1: " <> Integer.to_string(NaiveDateTime.diff(time_t2, time_t1, :millisecond))<> "ms")
IO.puts("Time p2: " <> Integer.to_string(NaiveDateTime.diff(time_t3, time_t2, :millisecond))<> "ms")

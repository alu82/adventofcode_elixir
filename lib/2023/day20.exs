defmodule Day20 do

  def part1() do
    push_n(1000) |> IO.inspect()
  end

  def part2() do
    push_rx()
  end

  defp push_n(times) do
    config = read_input()

    {total_low, total_high} =
      1..times
      |> Enum.map_reduce(
        config,
        fn _idx, cfg ->
          {next_config, _queue, {l_c, h_c}} = push(cfg)
          {{l_c, h_c}, next_config}
        end
      )
      |> elem(0)
      |> Enum.reduce({0,0}, fn {l_c, h_c}, {l_sum, h_sum} -> {l_sum + l_c, h_sum + h_c} end)
    total_low*total_high
  end

  defp push_rx() do
    config = read_input()

    # from inspecting my input I know 1. rx has only one predecessor (could have hardcoded it too)
    pred = config |> Enum.filter(fn {_k, {_t, _s, d}} -> "rx" in d end) |> Enum.map(fn {k, _v} -> k end) |> hd()

    1..10000
      |> Enum.reduce(
        {config, %{}},
        fn idx, {cfg, cycles} ->
          {next_config, _queue, _counts} = push(cfg)

          {_t, state, _d} = Map.get(next_config, pred)

          state |> Enum.reduce(
            cycles,
            fn {k,v}, cyc ->
              case v do
                :low -> cyc
                :high ->
                  IO.puts("-------------------------high")
                  upd_cycle = cyc |> Map.get(k, []) |> List.insert_at(-1, idx)
                  Map.put(cyc, k, upd_cycle)
              end
            end
          )

          {next_config, cycles}
        end
      )
  end

  defp push(config) do
    step(
      {config, FIFO.new() |> FIFO.push({"", "broadcaster", :low}), {1,0}},
      fn {config, queue, pulse_count = {l_c, h_c}} ->
        case FIFO.pop(queue) do
          {:empty, queue} -> {:halt, {config, queue, pulse_count}}
          {{:value, {from, to, in_pulse}}, rem_queue} ->
            {type, status, dest} = Map.get(config, to, {nil, nil, nil})
            case {type, status, in_pulse} do
              {"!", :low, :low} ->
                next_queue = dest |> Enum.map(&({to, &1, :low})) |> Enum.reduce(rem_queue, fn n, q -> FIFO.push(q, n) end)
                {:cont, {config, next_queue, {l_c + length(dest), h_c}}}
              {"%", :off, :low} ->
                next_queue = dest |> Enum.map(&({to, &1, :high})) |> Enum.reduce(rem_queue, fn n, q -> FIFO.push(q, n) end)
                next_config = Map.put(config, to, {type, :on, dest})
                {:cont, {next_config, next_queue, {l_c, h_c + length(dest)}}}
              {"%", :on, :low} ->
                next_queue = dest |> Enum.map(&({to, &1, :low})) |> Enum.reduce(rem_queue, fn n, q -> FIFO.push(q, n) end)
                next_config = Map.put(config, to, {type, :off, dest})
                {:cont, {next_config, next_queue, {l_c + length(dest), h_c}}}
              {"&", state, in_pulse} ->
                upd_state = state |> Map.put(from, in_pulse)
                {out_pulse, new_pulse_count} =
                  case upd_state |> Enum.all?(fn {_k,v} -> v==:high end) do
                    true -> {:low, {l_c + length(dest), h_c}}
                    false -> {:high, {l_c, h_c + length(dest)}}
                  end

                next_queue = dest |> Enum.map(&({to, &1, out_pulse})) |> Enum.reduce(rem_queue, fn n, q -> FIFO.push(q, n) end)
                next_config = Map.put(config, to, {type, upd_state, dest})
                {:cont, {next_config, next_queue, new_pulse_count}}

              _ -> {:cont, {config, rem_queue, pulse_count}}
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
    config_init = File.read(Path.dirname(__ENV__.file) <> "/day20.input")
      |> elem(1)
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, " -> "))
      |> Enum.map(
        fn [tname, dest] ->
          destinations = String.split(dest, ", ", trim: true)
          case tname do
            "broadcaster" -> {"broadcaster", "!", :low, destinations}
            _ ->
              {type, name} = String.split_at(tname, 1)
              case type do
                "%" -> {name, type, :off, destinations}
                "&" -> {name, type, :low, destinations}
              end
          end
        end
      )
      |> Enum.reduce(%{}, fn {n, t, p, d}, config -> Map.put(config, n, {t, p, d}) end)

    config =
      config_init
      |> Enum.filter(fn {_k, {t, _s, _d}} -> t=="&" end)
      |> Enum.reduce(
        config_init,
        fn {conj, {type, _state, dest}}, cfg ->
          new_state =
            cfg
            |> Enum.filter(fn {_k, {_t, _s, d}} -> Enum.member?(d, conj) end)
            |> Enum.map(fn {k,_v} -> {k, :low} end)
            |> Enum.into(%{})
            Map.put(cfg, conj, {type, new_state, dest})
        end
      )

    config
  end

end

time_t1 = NaiveDateTime.utc_now
Day20.part1()
time_t2 = NaiveDateTime.utc_now
Day20.part2()
time_t3 = NaiveDateTime.utc_now
IO.puts("Time p1: " <> Integer.to_string(NaiveDateTime.diff(time_t2, time_t1, :millisecond))<> "ms")
IO.puts("Time p2: " <> Integer.to_string(NaiveDateTime.diff(time_t3, time_t2, :millisecond))<> "ms")

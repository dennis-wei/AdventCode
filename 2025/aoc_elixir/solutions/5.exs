defmodule Day5 do
  def get_input(test \\ false) do
    filename = case test do
      false -> "input/5.txt"
      true -> "test_input/5.1.txt"
    end
    Input
      # .ints(filename)
      .line_tokens(filename, "\n", "\n\n")
      # .lines(filename)
      # .line_of_ints(filename)
      # .ints_in_lines(filename)
  end

  def merge({l1, r1}, {l2, r2}) do
    cond do
      r1 >= l2 -> {true, {l1, max(r1, r2)}}
      true -> {false, nil}
    end
  end

  def merge_intervals(intervals) do
    sorted = Enum.sort_by(intervals, fn {l, _r} -> l end)
    Enum.reduce_while(1..1000000, {[], sorted}, fn (_, {resolved, unresolved}) ->
      case unresolved do
        [] -> {:halt, Enum.reverse(resolved)}
        [single] -> {:cont, {[single | resolved], []}}
        _ ->
          [l | [r | rem]] = unresolved
          {did_merge, merged} = merge(l, r)
          case did_merge do
            true -> {:cont, {resolved, [merged | rem]}}
            false -> {:cont, {[l | resolved], [r | rem]}}
          end
        end
      end)
  end

  def solve(test \\ false) do
    [raw_ranges, ingredients] = get_input(test)
    ranges = raw_ranges
      |> Enum.map(fn s ->
        [l, r] = Utils.get_all_nums(s, false)
        {l, r}
      end)
    part1 = ingredients
      |> Enum.map(&String.to_integer/1)
      |> Enum.count(fn i ->
      Enum.any?(ranges, fn {l, r} ->
        l <= i and r >= i
      end)
    end)
    part2 = merge_intervals(ranges)
      |> Enum.map(fn {n1, n2} -> n2 - n1 + 1 end)
      |> Enum.sum
    IO.puts("Part 1: #{part1}")
    IO.puts("Part 2: #{part2}")
  end
end

Day5.solve()

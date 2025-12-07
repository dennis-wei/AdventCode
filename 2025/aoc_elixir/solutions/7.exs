defmodule Day7 do
  def get_input(test \\ false) do
    filename = case test do
      false -> "input/7.txt"
      true -> "test_input/7.txt"
    end
    Input
      # .ints(filename)
      # .line_tokens(filename)
      .lines(filename)
      # .line_of_ints(filename)
      # .ints_in_lines(filename)
  end

  def part1(initial_cols, rows) do
    Enum.reduce(rows, {initial_cols, 0}, fn (row, {cols, num_splits}) ->
      Enum.with_index(row)
        |> Enum.reduce({MapSet.new(), num_splits}, fn ({r, i}, {icols, nsplits}) ->
          cond do
            r == "^" && MapSet.member?(cols, i) ->
              uset = icols
                |> MapSet.put(i - 1)
                |> MapSet.put(i + 1)
              {uset, nsplits + 1}
            MapSet.member?(cols, i) -> {MapSet.put(icols, i), nsplits}
            true -> {icols, nsplits}
          end
        end)
      end)
      |> then(&elem(&1, 1))
  end

  def part2(starting_row, rows) do
    initial = Enum.map(starting_row, fn c ->
      case c do
        "." -> 0
        "S" -> 1
      end
    end)

    Enum.reduce(rows, initial, fn (row, acc) ->
      zipped = Enum.zip(row, acc)
        |> Enum.with_index

      res = Enum.reduce(zipped, Map.new(), fn ({{c, above}, i}, macc) ->
        case c do
          "^" -> macc
            |> Map.update(i - 1, above, fn n -> n + above end)
            |> Map.update(i + 1, above, fn n -> n + above end)
            |> Map.put(i, 0)
          _ -> macc
            |> Map.update(i, above, fn n -> n + above end)
        end
      end)
        |> Map.to_list()
        |> Enum.sort_by(fn {idx, _n} -> idx end)
        |> Enum.map(fn {_idx, n} -> n end)
      res
    end)
  end

  def solve(test \\ false) do
    [starting_row | rows] = get_input(test)
      |> Enum.map(&String.graphemes/1)
    initial_cols = Enum.with_index(starting_row)
      |> Enum.filter(fn {c, _i} -> c == "S" end)
      |> Enum.map(&elem(&1, 1))
      |> MapSet.new()
    part1 = part1(initial_cols, rows)
    part2 = part2(starting_row, rows)
      |> Enum.sum()
    IO.puts("Part 1: #{part1}")
    IO.puts("Part 2: #{part2}")
  end
end

Day7.solve()

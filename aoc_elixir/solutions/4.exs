defmodule Day4 do
  def get_input(test \\ false) do
    filename = case test do
      false -> "input/4.txt"
      true -> "test_input/4.txt"
    end
    Input
      # .ints(filename)
      # .line_tokens(filename)
      .lines(filename)
      # .line_of_ints(filename)
      # .ints_in_lines(filename)
  end

  def reachable(grid) do
    grid
      |> Enum.filter(fn {c, v} ->
        v == "@" and Grid.get_neighbors(grid, c, true)
          |> Enum.filter(fn {_c, v} -> v == "@" end)
          |> Enum.count
          |> then(fn n -> n < 4 end)
      end)
  end

  def part1(grid) do
      reachable(grid)
        |> Enum.count
  end

  def part2(grid, num_removed \\ 0) do
    to_edit = reachable(grid)
    case to_edit do
      [] -> num_removed
      _ ->
        removed = Enum.reduce(to_edit, grid, fn ({c, _v}, grid_acc) ->
          Map.put(grid_acc, c, ".")
        end)
        part2(removed, num_removed + Enum.count(to_edit))
    end
  end

  def solve(test \\ false) do
    input = get_input(test)
      |> Enum.map(&String.graphemes/1)
      |> Grid.make_grid
    part1 = part1(input)
    part2 = part2(input)
    IO.puts("Part 1: #{part1}")
    IO.puts("Part 2: #{part2}")
  end
end

Day4.solve()

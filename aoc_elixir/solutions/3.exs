defmodule Day3 do
  def get_input(test \\ false) do
    filename = case test do
      false -> "input/3.txt"
      true -> "test_input/3.txt"
    end
    Input
      # .ints(filename)
      # .line_tokens(filename)
      # .lines(filename)
      # .line_of_ints(filename)
      # .ints_in_lines(filename)
  end

  def solve(test \\ false) do
    input = get_input(test)
    part1 = nil
    part2 = nil
    IO.puts("Part 1: #{part1}")
    IO.puts("Part 2: #{part2}")
  end
end

Day3.solve()
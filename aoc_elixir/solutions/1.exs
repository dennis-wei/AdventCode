defmodule Day1 do
  def get_input(test \\ false) do
    filename = case test do
      false -> "input/1.txt"
      true -> "test_input/1.txt"
    end
    Input
      # .ints(filename)
      # .line_tokens(filename)
      .lines(filename)
      # .line_of_ints(filename)
      # .ints_in_lines(filename)
  end

  def modulo(n, base) do
    res = rem(n, base)
    cond do
      res < 0 -> res + base
      true -> res
    end
  end

  def iter(str, start) do
    {dir, rem} = String.split_at(str, 1)
    n = String.to_integer(rem)
    nend = case dir do
      "R" -> start + n
      "L" -> start - n
    end
    base = cond do
      start == 0 -> 0
      dir == "L" && start - n <= 0 -> 1
      true -> 0
    end
    num_crosses = base + case dir do
      "R" -> div(nend, 100)
      "L" -> div(-nend, 100)
    end
    case dir do
      "R" -> {modulo(start + n, 100), num_crosses}
      "L" -> {modulo(start - n, 100), num_crosses}
    end
  end

  def solve(test \\ false) do
    input = get_input(test)
    {_, part1, part2} = Enum.reduce(input, {50, 0, 0}, fn (row, {acc, ct1, ct2}) ->
      {res, cross} = iter(row, acc)
      case res do
        0 -> {res, ct1 + 1, ct2 + cross}
        _ -> {res, ct1, ct2 + cross}
      end
    end)
    IO.puts("Part 1: #{part1}")
    IO.puts("Part 2: #{part2}")
  end
end

Day1.solve()

defmodule Day2 do
  def get_input(test \\ false) do
    filename = case test do
      false -> "input/2.txt"
      true -> "test_input/2.txt"
    end
    Input
      # .ints(filename)
      .line_tokens(filename, ~r/[-,]/)
      # .lines(filename)
      # .line_of_ints(filename)
      # .ints_in_lines(filename)
  end

  def is_invalid_pt1(n) do
    str = Integer.to_string(n)
    {left, right} = String.split_at(str, div(String.length(str), 2))
    left == right
  end

  def is_repeating(whole_str, pattern) do
    String.replace(whole_str, pattern, "") == ""
  end

  def is_invalid_pt2(n) do
    cond do
      n < 10 -> false
      true ->
        str = Integer.to_string(n)
        candidates = (1..div(String.length(str), 2))
          |> Enum.map(&String.slice(str, 0..&1-1))
        Enum.any?(candidates, &is_repeating(str, &1))
    end
  end

  def get_invalid([n1, n2], part2 \\ false) do
    Enum.filter(n1..n2, fn n ->
      case part2 do
        false -> is_invalid_pt1(n)
        true -> is_invalid_pt2(n)
      end
    end)
  end

  def solve(test \\ false) do
    input = get_input(test)
      |> Enum.at(0)
      |> Enum.map(&String.to_integer/1)
      |> Enum.chunk_every(2)
    part1 = input
      |> Enum.flat_map(&get_invalid(&1, false))
      |> Enum.sum
    part2 = input
      |> Enum.flat_map(&get_invalid(&1, true))
      |> Enum.sum
    IO.puts("Part 1: #{part1}")
    IO.puts("Part 2: #{part2}")
  end
end

Day2.solve(false)

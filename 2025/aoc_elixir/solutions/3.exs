defmodule Day3 do
  def get_input(test \\ false) do
    filename = case test do
      false -> "input/3.txt"
      true -> "test_input/3.txt"
    end
    Input
      # .ints(filename)
      # .line_tokens(filename)
      .lines(filename)
      # .line_of_ints(filename)
      # .ints_in_lines(filename)
  end

  def handle_line(line, part2 \\ false) do
    chars = String.graphemes(line)
      |> Enum.map(&String.to_integer/1)

    case part2 do
      false -> handle_rem(chars, 0, 2)
      true -> handle_rem(chars, 0, 12)
    end
  end

  def handle_rem(list, acc, num_remaining) do
    size = Enum.count(list)

    {max, idx} = list
      |> Enum.slice(0..size-num_remaining)
      |> Enum.with_index
      |> Enum.max_by(&elem(&1, 0))
    case num_remaining do
      1 -> 10 * acc + max
      _ -> handle_rem(Enum.slice(list, idx+1..size-1), 10 * acc + max, num_remaining - 1)
    end
  end

  def solve(test \\ false) do
    input = get_input(test)
    part1 = input
      |> Enum.map(&handle_line/1)
      |> Enum.sum
    part2 = input
      |> Enum.map(&handle_line(&1, true))
      |> Enum.sum
    IO.puts("Part 1: #{part1}")
    IO.puts("Part 2: #{part2}")
  end
end

Day3.solve()

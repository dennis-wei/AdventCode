defmodule Day6 do
  def get_input(test \\ false) do
    filename = case test do
      false -> "input/6.txt"
      true -> "test_input/6.txt"
    end
    Input
      # .ints(filename)
      # .line_tokens(filename)
      .lines(filename)
      # .line_of_ints(filename)
      # .ints_in_lines(filename)
  end

  def split(line, split_locs) do
    pairs = Enum.zip(split_locs, tl(split_locs))
    first = String.slice(line, 0, hd(split_locs))
    last_split = Enum.take(split_locs, -1) |> hd
    last = String.slice(line, last_split + 1, String.length(line))
    middle = Enum.map(pairs, fn {l, r} ->
      String.slice(line, l + 1, r - l - 1)
    end)
    [first] ++ middle ++ [last]
  end

  def calc([op | nums]) do
    as_ints = Enum.map(nums, &String.to_integer/1)
    case op do
      "+" -> Enum.sum(as_ints)
      "*" -> Enum.product(as_ints)
    end
  end

  def parse(lines) do
    space_locs = Enum.map(lines, fn line ->
      String.graphemes(line)
        |> Enum.with_index
        |> Enum.filter(fn {c, _idx} ->
          c == " "
        end)
        |> Enum.map(&elem(&1, 1))
        |> MapSet.new
    end)
    [s1 | rem] = space_locs
    split_locs = Enum.reduce(rem, s1, fn (ls, rs) -> MapSet.intersection(ls, rs) end)
      |> MapSet.to_list
      |> Enum.sort
    splits = Enum.map(lines, &split(&1, split_locs))
    Enum.zip(splits)
      |> Enum.map(&Tuple.to_list/1)
      |> Enum.map(&Enum.reverse/1)
  end

  def part1(parsed) do
    Enum.map(parsed, &String.trim/1)
      |> then(&calc/1)
  end

  def part2(parsed) do
    [raw_op | raw_nums] = parsed
    op = String.trim(raw_op)
    nums = raw_nums
      |> Enum.reverse
      |> Enum.map(&String.graphemes/1)
      |> Enum.zip
      |> Enum.map(&Tuple.to_list/1)
      |> Enum.map(&Enum.join/1)
      |> Enum.map(&String.trim/1)
      |> Enum.map(&String.to_integer/1)
    case op do
      "+" -> Enum.sum(nums)
      "*" -> Enum.product(nums)
    end
  end

  def solve(test \\ false) do
    input = get_input(test)
    parsed = parse(input)
    part1 = Enum.map(parsed, &part1/1)
      |> Enum.sum
    part2 = Enum.map(parsed, &part2/1)
      |> Enum.sum
    IO.puts("Part 1: #{part1}")
    IO.puts("Part 2: #{part2}")
  end
end

Day6.solve()

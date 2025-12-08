defmodule Day8 do
  def get_input(test \\ false) do
    filename = case test do
      false -> "input/8.txt"
      true -> "test_input/8.txt"
    end
    Input
      # .ints(filename)
      # .line_tokens(filename)
      # .lines(filename)
      # .line_of_ints(filename)
      .ints_in_lines(filename)
  end

  def get_dist({x1, y1, z1}, {x2, y2, z2}) do
    :math.pow(x1 - x2, 2) + :math.pow(y1 - y2, 2) + :math.pow(z1 - z2, 2)
  end

  def solution(coords, test \\ false) do
    dists = Comb.combinations(coords, 2)
      |> Enum.map(fn [c1, c2] -> {c1, c2, get_dist(c1, c2)} end)
      |> Enum.sort_by(fn {_c1, _c2, d} -> d end)

    initial = Enum.reduce(coords, Graph.new(type: :undirected), fn (c, acc) ->
      Graph.add_vertex(acc, c)
    end)
    iters = case test do
      true -> 10
      false -> 1000
    end

    part1 = dists
      |> Enum.zip(1..iters)
      |> Enum.reduce(initial, fn ({{c1, c2, _d},_i}, acc) ->
        Graph.add_edge(acc, c1, c2)
      end)
      |> Graph.components()
      |> Enum.map(fn c -> Enum.count(c) end)
      |> Enum.sort()
      |> Enum.reverse()
      |> Enum.take(3)
      |> Enum.product()

    part2 = Enum.reduce_while(dists, initial, fn ({c1, c2, _d}, acc) ->
      new_graph = Graph.add_edge(acc, c1, c2)
      [_hd | tl] = Graph.components(new_graph)
      case tl do
        [] -> {:halt, {c1, c2}}
        _ -> {:cont, new_graph}
      end
    end)
      |> IO.inspect()
      |> then(fn {{x1, _y1, _z1}, {x2, _y2, _z2}} -> x1 * x2 end)

    {part1, part2}
  end

  def solve(test \\ false) do
    input = get_input(test)
      |> Enum.map(&List.to_tuple/1)
    {part1, part2} = solution(input, test)
    IO.puts("Part 1: #{part1}")
    IO.puts("Part 2: #{part2}")
  end
end

Day8.solve()

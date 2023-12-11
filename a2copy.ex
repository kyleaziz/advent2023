defmodule AoC2 do
  defmodule Pull do
    defstruct red: 0, green: 0, blue: 0
  end

  def parse(input_file \\ System.fetch_env!("INPUT_FILE")) do
    input_file
    |> File.read!()
    |> String.split("\n")
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(&parse_game/1)
    |> Map.new()
  end

  def parse_game("Game " <> game) do
    {id, rest} = Integer.parse(game)
    <<": ">> <> pulls = rest

    pulls =
      pulls
      |> String.trim()
      |> String.split(";")
      |> Enum.map(&String.trim/1)
      |> Enum.map(&parse_pull/1)

    {id, pulls}
  end

  def parse_pull(pull) do
    result =
      pull
      |> String.split(",")
      |> Enum.map(&String.trim/1)
      |> Enum.map(&parse_pull_color/1)

    struct!(Pull, result)
  end

  def parse_pull_color(result) do
    case Integer.parse(result) do
      {num, " red"} -> {:red, num}
      {num, " green"} -> {:green, num}
      {num, " blue"} -> {:blue, num}
    end
  end

  @red_limit 12
  @green_limit 13
  @blue_limit 14

  def solve(input) do
    input
    |> Enum.filter(fn {_id, pulls} ->
      Enum.all?(pulls, fn
        %{red: red, green: green, blue: blue}
        when red <= @red_limit and green <= @green_limit and blue <= @blue_limit ->
          true

        _ ->
          false
      end)
    end)
    |> Enum.map(fn {id, _} -> id end)
    |> Enum.sum()
  end

  def solve2(input) do
    input
    |> Enum.map(fn {id, pulls} ->
      min_red = pulls |> Enum.map(&Map.fetch!(&1, :red)) |> Enum.max()
      min_green = pulls |> Enum.map(&Map.fetch!(&1, :green)) |> Enum.max()
      min_blue = pulls |> Enum.map(&Map.fetch!(&1, :blue)) |> Enum.max()

      {id, min_red * min_green * min_blue}
    end)
    |> Enum.map(fn {_id, power} -> power end)
    |> Enum.sum()
  end
end

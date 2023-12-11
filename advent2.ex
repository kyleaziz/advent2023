defmodule Adv2 do
  # parse the file into a list of lines
  def fetch(filename) do
    {:ok, contents} = File.read(filename)
    String.split(contents, "\n", trim: true)
  end

  def checkGame(game) do
    {id, pullList} = convert(game)
    possible = splitter(pullList) |> checkMany
    id * possible
  end

  # parse set into the id and the list of pulls
  def convert(set) do
    [ "Game "<>idStr | [pullStr] ] = String.split(set, ": ", trim: true)
    {gameId, _} = Integer.parse(idStr)
    pullList =  String.split(pullStr, "; ", trim: true)
    {gameId, pullList}
  end

  # compare against the possibilities OR parse the sets and get the max for each
  def checkMany(pullList, possible \\ 1)
  def checkMany(_pullList, 0) do
    0
  end
  def checkMany([], possible) do
    possible
  end
  def checkMany([pullList | remainingPulls], _possible) do
     checkMany(remainingPulls, check(pullList))
  end

  def check(pull) do
    [quantityStr, colorStr] = String.split(pull, " ")
    {colorStr, String.to_integer(quantityStr)} |> checkOne
  end

  # Checks single pull for possibility
  def checkOne({"green",numGreen}) when numGreen <= 13 do
    1
  end
  def checkOne({"blue",numBlue}) when numBlue <= 14 do
    1
  end
  def checkOne({"red",numRed}) when numRed <= 12 do
    1
  end
  def checkOne({_colorString,_num}) do
    0
  end

  # Splits Pullsets into individual pulls for feeding into checkMany
  def splitter(gamePulls, pullList \\ [])
  def splitter([], pullList) do
    pullList
  end

  def splitter([pull|remaining], pullList) do
    pulls = String.split(pull,", ")
    splitter(remaining, Enum.concat(pulls, pullList))
  end

  def checkGames(gameList, sum \\ 0)
  def checkGames([], sum), do: sum
  def checkGames([game | remainingGames], sum) do
    checkGames(remainingGames, sum + checkGame(game))
  end

  # PART 2 : Check for the minimum number of cubes to make the games possible

  # for a pullList, keep the min amount needed to be true
  def gamePower(game) do
    {_id, pullList} = convert(game)
    [minRed, minBlue, minGreen] = splitter(pullList) |> getMins([])
    minRed * minBlue * minGreen
  end

  def getMins(pullList, []) do
    getMins(pullList, [0, 0, 0])
  end
  def getMins([], [r, g, b]) do
    [r, g, b]
  end
  def getMins([pull|remaining], [minRed, minGreen, minBlue]) do
    [val, color] = String.split(pull, " ")
    getMins(remaining, returnMins(val, color, minRed, minGreen, minBlue))
  end
  # def getMins([b<>" blue"|remaining], minRed, minGreen, returnGreater(String.to_integer(b),minBlue)) do
  #   getMins(remaining, minRed, minGreen, minBlue)
  # end
  # def getMins([g<>" green"|remaining], minRed, minGreen, minBlue) do
  #   getMins(remaining, minRed, returnGreater(String.to_integer(g),minGreen), minBlue)
  # end
  # def getMins([pull|remaining], minRed, minGreen, minBlue) do
  #   getMins(remaining, minRed, minGreen, minBlue)
  # end

  def returnMins(val, "red", r, g, b) do
    [returnGreater(String.to_integer(val),r), g, b]
  end
  def returnMins(val, "green", r, g, b) do
    [r, returnGreater(String.to_integer(val),g), b]
  end
  def returnMins(val, "blue", r, g, b) do
    [r, g, returnGreater(String.to_integer(val),b)]
  end

  def returnGreater(a,b) when a >= b do
    a
  end
  def returnGreater(_a,b) do
    b
  end

  def solvePower(gameList, currentSum \\ 0)
  def solvePower([], currentSum) do
    currentSum
  end
  def solvePower([game|remaining], currentSum) do
    solvePower(remaining, currentSum + gamePower(game))
  end
end

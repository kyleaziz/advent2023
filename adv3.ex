defmodule Engine do
  def fetch do
    {:ok, contents} = File.read("input3.txt")
    String.split(contents, "\n", trim: true)
  end

  def fetchSample do
    {:ok, contents} = File.read("sample3.txt")
    String.split(contents, "\n", trim: true)
  end

  def findSymbols(line) do
    String.graphemes(line)
  end

  def splitLines(list, results \\ [])
  def splitLines([],results), do: results
  def splitLines([line|rest],results) do
    lineResults = line |>
    findSymbols |>
    getLocations
    splitLines(rest, Enum.concat(results, [lineResults]))
  end

  def getLocations(list, locations \\ [])
  def getLocations([], locations) do
    locations
  end
  def getLocations([symbol|remaining], locations) do
    result = isSymbol(symbol)
    getLocations(remaining, Enum.concat(locations, [result]))
  end

  def isSymbol(char) do
    case(char) do
      "@" -> 1
      "#" -> 1
      "$" -> 1
      "%" -> 1
      "&" -> 1
      "*" -> 1
      "-" -> 1
      "+" -> 1
      "=" -> 1
      # "." -> 0
      _ -> 0
    end
  end

  def markAdj(list, results \\ [], carry \\ 0)
  # def markAdj([], results, _carry) do
  #   results
  # end
  def markAdj([first|remaining], [], _carry) do
    case({first, hd(remaining)}) do
      {1, _} -> markAdj(remaining, [1], 1)
      {0, 1} -> markAdj(remaining, [1], 0)
      {0, 0} -> markAdj(remaining, [0], 0)
    end
  end
  def markAdj([last|[]], results, carry) do
    case({last, carry}) do
      {0, 0} -> Enum.concat(results,[0])
      {_, _} -> Enum.concat(results,[1])
    end
  end
  def markAdj([marker|remaining], results, carry) do
    case({carry, marker, remaining}) do
      {_, 1, _} -> markAdj(remaining, Enum.concat(results, [1]), 1)
      {1, 0, _} -> markAdj(remaining, Enum.concat(results, [1]), 0)
      {_, _, []} -> markAdj(remaining, Enum.concat(results, [0]),0)
      {0, 0, remaining} -> markAdj(remaining, Enum.concat(results, [hd(remaining)]), 0)
    end
  end

  def tableAdj(table,results \\ [])
  def tableAdj([],results), do: results
  def tableAdj([line|rest], results) do
    tableAdj(rest, Enum.concat(results,[markAdj(line)]))
  end

  # def expLocs(table, previousLine \\ [], result)
  # def expLocs([firstLine|rest], [], results) do
  #   firstLine
  # end

  # def tableVert(table = [row|rest], previousRow \\ [], result)
  # def tableVert([], _previousRow, result), do: result
  # def tableVert(table = [row|rest], previousRow, result) do

  # end

  def rowVert(row1,row2, row3 \\ [], result \\ [])
  def rowVert([],_row2, _row3, result), do: result
  def rowVert([val|rest], [pVal|pRest], [], result) do
    rowVert(rest,pRest,[],Enum.concat(result,evalVert(val,pVal)))
  end
  def rowVert([val|rest], [pVal|pRest], [nVal|nRest], result) do
    rowVert(rest,pRest,nRest,Enum.concat(result,evalVert(val,pVal,nVal)))
  end
  # def evalVert([], val, nVal) do
  #   case(val+nVal) do
  #     0 -> 0
  #     _ -> 1
  #   end
  # end
  def evalVert(val1,val2,val3 \\ 0)
  def evalVert(pVal, val, 0) do
    case(val+pVal) do
      0 -> 0
      _ -> 1
    end
  end
  def evalVert(pVal, val, nVal) do
    case(pVal+val+nVal) do
      0 -> 0
      _ -> 1
    end
  end

  # Formula to get part numbers next to symbol(s)
  def getHits(input_row, hitlist_row, numbucket \\ [], numcarry \\ [])
  def getHits([inHead | inRest], [hitHead | hitRest], numbucket, numcarry) do
    # iterate through hitlist and if it's a 1, check if that spot is a number in the input_row
    input = case(Integer.parse(inHead)) do
      :error -> 0
      {num, ""} -> num
    end
    case({input, hitHead, length(numcarry)}) do
      {:error, _, 0} -> getHits(inRest, hitRest, numbucket, [])
      {:error, _, _} -> getHits(inRest, hitRest, Enum.concat(numbucket, [genPN(numcarry)]), [])
      {input, 0, 0} -> getHits(inRest, hitRest, numbucket, Enum.concat(numcarry,[input]))
    end
    # for numbers, check against hits
  end

  def genPN(list) do
    case(length(list)) do
      3 -> 100*hd(list)+10*hd(tl(list))+hd(tl(tl(list)))
      2 -> 10*hd(list)+hd(tl(list))
      1 -> hd(list)
      0 -> 0
    end
  end

end

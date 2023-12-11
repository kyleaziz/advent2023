defmodule Aoc1 do
  def readfile(filename) do
    {:ok, contents} = File.read(filename)
    String.split(contents, "\n",trim: true)
  end

  def digiparser(string) do
    translate(string) |>
    String.graphemes()
  end

  def numGrab(list, current_first \\ nil, current_last \\ nil)
  def numGrab([], current_first, current_last) when current_last == nil do
    10 * current_first + current_first
  end
  def numGrab([], current_first, current_last) do
    10 * current_first + current_last
  end
  def numGrab([head|tail], current_first, _current_last) when current_first == nil do
    case Integer.parse(head) do
      {numFound,""} -> numGrab(tail, numFound)
      _ -> numGrab(tail)
    end
  end
  def numGrab([head|tail], current_first, current_last) when current_last == nil do
    case Integer.parse(head) do
      {numFound,""} -> numGrab(tail, current_first, numFound)
      _ -> numGrab(tail, current_first)
    end
  end
  def numGrab([head|tail], current_first, current_last) do
    case Integer.parse(head) do
      {numFound,""} -> numGrab(tail, current_first, numFound)
      _ -> numGrab(tail, current_first, current_last)
    end
  end

  def summer(list, current_total \\ nil)
  def summer([],total) do
    total
  end
  def summer([head|tail], current_total) when current_total == nil do
    summer(tail, numGrab(digiparser(head)))
  end
  def summer([head|tail], current_total) do
    summer(tail, current_total + numGrab(digiparser(head)))
  end

  def translate(string) do
    string |>
    String.replace("one", "o1e") |>
    String.replace("two", "t2o") |>
    String.replace("three", "t3e") |>
    String.replace("four", "f4r") |>
    String.replace("five", "f5e") |>
    String.replace("six", "s6x") |>
    String.replace("seven", "s7n") |>
    String.replace("eight", "e8t") |>
    String.replace("nine", "n9e")
  end
# 54504 is the adjusted answer
# 54597 is the original answer
end

defmodule MyList do
  # ListsAndRecursion-1
  def mapsum(list, func, val \\ 0)
  def mapsum([], _func, val) do
    val
  end
  def mapsum([head | tail], func, val) do
    mapsum(tail, func, val + func.(head))
  end

  # ListsAndRecursion-2
  def maxl(list, current_max \\ nil)
  def maxl([], current_max) do
    current_max
  end
  def maxl([head|tail], current_max) when current_max == nil do
    maxl(tail, head)
  end
  def maxl([head|tail], current_max) when head <= current_max do
    maxl(tail, current_max)
  end
  def maxl([head|tail], current_max) when head > current_max do
    maxl(tail, head)
  end

  # ListsAndRecursion-3
  def caesar([], _n) do
    []
  end
  def caesar([head|tail], n) when (head + n) > 122 do
    [head + n - 26 | caesar(tail, n)]
  end
  def caesar([head|tail], n) do
    [head + n | caesar(tail, n)]
  end

  # ListsAndRecursion-4
  def span(from, to) when to == from do
    [to]
  end
  def span(from, to) when to < from do
    span(to, from)
  end
  def span(from, to) do
    [from | span(from + 1, to)]
  end

end

defmodule PbtTest do
  use ExUnit.Case
  use PropCheck

  property "finds biggest element" do
    forall x <- integer() |> list() |> non_empty() do
      Pbt.biggest(x) == model_biggest(x)
    end
  end

  def model_biggest(list) do
    list |> Enum.sort() |> List.last()
  end

  property "picks the last number" do
    forall {list, known_last} <- { number() |> list(), number() } do
      known_list = list ++ [known_last]
      known_last == List.last(known_list)
    end
  end

  property "a sorted list has ordered pairs" do
    forall list <- term() |> list() do
      list |> Enum.sort |> ordered?()
    end
  end

  def ordered?([a, b| t]) do
    a <= b and ordered?([ b | t])
  end

  def ordered?(_) do
    true
  end

  property "a sorted list keeps its size" do
    forall l <- number() |> list() do
      length(l) == Enum.sort(l) |> length()
    end
  end

  property "no element added" do
    forall l <- number() |> list() do
      sorted = Enum.sort(l) 
      Enum.all?(sorted, fn element -> element in l end)
    end    
  end

  property "no element deleted" do
    forall l <- number() |> list() do
      sorted = Enum.sort(l) 
      Enum.all?(l, fn element -> element in sorted end)
    end    
  end

  property "symmetric encoding/decoding" do
    forall data <- list( {atom(), any()} ) do
      encoded = Pbt.encode(data)
      is_binary(encoded) and data == Pbt.decode(encoded)
    end
  end

end

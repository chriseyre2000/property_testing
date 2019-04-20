defmodule PbtTest do
  use ExUnit.Case
  use PropCheck

  property "always works" do
    forall type <- my_type() do
      boolean(type)
    end
  end

  property "finds biggest element" do
    forall x <- integer() |> list() |> non_empty() do
      biggest(x) == x |> Enum.sort |> List.last
    end
  end

  defp boolean(_) do
    true
  end

  def my_type() do
    term()
  end

  # This is a fake function to test
  def biggest([head | tail]) do
    biggest(tail, head)
  end

  defp biggest([], max) do
    max
  end

  defp biggest([head | tail], max) when head >= max do
    biggest(tail, head)
  end

  defp biggest([head | tail], max) when head < max do
    biggest(tail, max)
  end

end

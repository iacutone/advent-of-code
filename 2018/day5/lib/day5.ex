defmodule Day5 do
  @doc """
  Collapse the polymers when letters can be removed.

  ## Examples

      iex> Day5.react("dabAcCaCBAcCcaDA")
      "dabCBAcaDA"

  """
  def react(polymer) when is_binary(polymer), 
    do: discard_and_react(polymer, [], nil, nil)

  @doc """
  Collapse the polymers when letters can be removed.

  ## Examples

      iex> Day5.discard_and_react("dabAcCaCBAcCcaDA", ?A, ?a)
      "dbCBcD"

  """
  def discard_and_react(polymer, letter1, letter2) when is_binary(polymer), 
    do: discard_and_react(polymer, [], letter1, letter2)

  defp discard_and_react(<<letter, rest::binary>>, acc, discard1, discard2)
    when letter == discard1
    when letter == discard2,
    do: discard_and_react(rest, acc, discard1, discard2)

  defp discard_and_react(<<letter1, rest::binary>>, [letter2 | acc], discard1, discard2) 
    when abs(letter1 - letter2) == 32,
    do: discard_and_react(rest, acc, discard1, discard2)
    
  defp discard_and_react(<<letter, rest::binary>>, acc, discard1, discard2),
    do: discard_and_react(rest, [letter | acc], discard1, discard2)

  defp discard_and_react(<<>>, acc, _discard1, _discard2),
    do: acc |> Enum.reverse() |> List.to_string()

  @doc """
  ## Examples

      iex> Day5.find_problematic("dabAcCaCBAcCcaDA")
      {?C, 4}

  """
  def find_problematic(polymer) do
    letters_and_length =
      for letter <- ?A..?Z do
        {letter, byte_size(discard_and_react(polymer, letter, letter + 32))}
      end

    Enum.min_by(letters_and_length, &elem(&1, 1))
  end
end

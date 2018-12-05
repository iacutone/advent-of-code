defmodule Day2 do

  def checksum(list) when is_list(list) do
    {twices, thrices} = 
      list
      |> Enum.map(fn box_id ->
        box_id
        |> count_characters()
        |> get_twice_and_thrice()
      end)
      |> Enum.reduce({0,0}, fn {twice, thrice}, {total_twice, total_thrice} ->
        {twice + total_twice, thrice + total_thrice}
      end)

    twices * thrices
  end

  def closest([head | tail]) do
    if closest = Enum.find(tail, &one_char_difference(&1, head)) do

      charlist1 = String.to_charlist(head)
      charlist2 = String.to_charlist(closest)

      charlist1
      |> Enum.zip(charlist2)
      |> Enum.filter(fn {cp1, cp2} -> cp1 == cp2 end)
      |> Enum.map(fn {cp, _} -> cp end)
      |> List.to_string
    else
      closest(tail)
    end
  end

  def one_char_difference(string1, string2) do
    charlist1 = String.to_charlist(string1)
    charlist2 = String.to_charlist(string2)

    charlist1
    |> Enum.zip(charlist2)
    |> Enum.count(fn {cp1, cp2} -> cp1 != cp2 end)
    |> Kernel.==(1)
  end

  def get_twice_and_thrice(characters) when is_map(characters) do
    twice = Enum.count(characters, fn {_codepoint, count} -> count == 2 end)
    thrice = Enum.count(characters, &match?({_codepoint, 3}, &1))
    {min(twice, 1), min(thrice, 1)}
  end

  def count_characters(string) when is_binary(string) do
    string
    |> String.to_charlist()
    |> Enum.reduce(%{}, fn codepoint, acc ->
      Map.update(acc, codepoint, 1, & &1 +1)
    end)
  end
end

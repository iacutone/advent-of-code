defmodule Day3 do
  @type claim :: String.t
  @type parsed_claim :: list
  @type coordinate :: {pos_integer, pos_integer}
  @type id :: integer

  @doc """
  Parses a claim.

  ## Examples

      iex> Day3.parse_claim("#1 @ 100,366: 24x27")
      [1, 100, 366, 24, 27]

  """

  @spec parse_claim(claim) :: list 
  def parse_claim(string) when is_binary(string) do
    string
    |> String.split(["#", " @ ", ",", ": ", "x"], trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  @doc """
  Retrieve all claimed inches.


  ## Examples

  iex> claimed = Day3.claimed_inches([
  ...> "#1 @ 1,3: 4x4",
  ...> "#2 @ 3,1: 4x4",
  ...> "#3 @ 5,5: 2x2"
  ...> ])
  iex> claimed[{4, 2}]
  [2]
  iex> claimed[{4, 4}]
  [2, 1]
  """

  @spec claimed_inches([claim]) :: %{coordinate => [id]}
  def claimed_inches(claims) do
    Enum.reduce(claims, %{}, fn claim, acc -> 
      [id, left, top, width, height] = parse_claim(claim)
      Enum.reduce((left + 1)..(left + width), acc, fn x, acc -> 
        Enum.reduce((top + 1)..(top + height), acc, fn y, acc -> 
          Map.update(acc, {x, y}, [id], &[id | &1])
        end)
      end)
    end)
  end

  @doc """
  Retrieves overlapped inches.

  ## Examples
    
  iex> Day3.overlapped_inches([
  ...> "#1 @ 1,3: 4x4",
  ...> "#2 @ 3,1: 4x4",
  ...> "#3 @ 5,5: 2x2"
  ...> ]) |> Enum.sort()
  [{4, 4}, {4, 5}, {5, 4}, {5, 5}]
  """

  @spec overlapped_inches([claim]) :: [coordinate]
  def overlapped_inches(claims) do
    for {coordinate, [_, _ | _]} <- claimed_inches(claims), do: coordinate
  end

  @doc """
  Retrieces non overlapping claim.

  ## Examples
    
  iex> Day3.non_overlapping_claim([
  ...> "#1 @ 1,3: 4x4",
  ...> "#2 @ 3,1: 4x4",
  ...> "#3 @ 5,5: 2x2"
  ...> ])
  3
  """

  @spec non_overlapping_claim(claim) :: id
  def non_overlapping_claim(claims) do
    overlapping_ids = MapSet.new(1..length(claims))

    {_inches, overlapping_ids} =
      Enum.reduce(claims, {%{}, overlapping_ids}, fn claim, acc ->
        [id, left, top, width, height] = parse_claim(claim)

        Enum.reduce((left + 1)..(left + width), acc, fn x, acc ->
          Enum.reduce((top + 1)..(top + height), acc, fn y, {inches, overlapping_ids} ->
            coordinate = {x, y}

            overlapping_ids = 
              case inches do
                %{^coordinate => [unique_id]} ->
                  overlapping_ids |> MapSet.delete(unique_id) |> MapSet.delete(id)
                %{^coordinate => _} ->
                  overlapping_ids |> MapSet.delete(id)
                %{} ->
                  overlapping_ids
              end
              {Map.update(inches, coordinate, [id], &[id | &1]), overlapping_ids}
          end)
        end)
      end)

    [id] = MapSet.to_list(overlapping_ids)
    id
  end
end

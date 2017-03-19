defmodule Elixirproject6 do
  @moduledoc """
  Documentation for Elixirproject6.
  """

  import Elixirproject6.CLI

  @default_count 4

  @doc """
  ## Examples

      iex> Elixirproject6.main()

  Handle the command line parsing and dispatch to
  the various functions that end up generating a
  """

  def main(argv) do
    argv
    |> parse_args
    |> process
  end

  defp process(:help) do
    IO.puts """
    usage: [ count | #{@default_count} ]
    """
    System.halt(0)
  end

end

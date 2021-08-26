defmodule GenReport do
  def build, do: {:error, "Insira o nome de um arquivo"}

  def build(filename) do
    filename
    |> GenReport.Parser.parse_file()
  end
end

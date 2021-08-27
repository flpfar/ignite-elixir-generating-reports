defmodule GenReport do
  @names [
    "cleiton",
    "daniele",
    "danilo",
    "diego",
    "giuliano",
    "jakeliny",
    "joseph",
    "mayk",
    "rafael",
    "vinicius"
  ]

  def build, do: {:error, "Insira o nome de um arquivo"}

  def build(filename) do
    filename
    |> GenReport.Parser.parse_file()
    |> Enum.reduce(all_hours(), & calculate_hours/2)
  end

  defp all_hours do
    %{
      all_hours: Enum.into(@names, %{}, & {&1, 0}),
    }
  end

  defp calculate_hours([name, hours, _, _, _], %{all_hours: all_hours}) do
    all_hours = Map.put(all_hours, name, all_hours[name] + hours)

    %{all_hours: all_hours}
  end
end

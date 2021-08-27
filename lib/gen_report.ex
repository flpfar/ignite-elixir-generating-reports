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
    |> Enum.reduce(report_acc(), & build_report/2)
  end

  defp report_acc do
    %{
      all_hours: Enum.into(@names, %{}, & {&1, 0}),
      hours_per_month: Enum.into(@names, %{}, fn name ->
        {name, Enum.into(GenReport.Months.months_list, %{}, & {&1, 0})}
      end)
    }
  end

  defp build_report([name, hours, _, month, _], %{all_hours: all_hours, hours_per_month: hours_per_month}) do
    all_hours = Map.put(all_hours, name, all_hours[name] + hours)
    hours_per_month_name = Map.put(hours_per_month[name], month, hours_per_month[name][month] + hours)
    hours_per_month = Map.put(hours_per_month, name, hours_per_month_name)

    %{all_hours: all_hours, hours_per_month: hours_per_month}
  end
end

defmodule GenReport do
  alias GenReport.DateHelper

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
    |> Enum.reduce(report_acc(), &build_report/2)
  end

  defp report_acc do
    %{
      all_hours: Enum.into(@names, %{}, &{&1, 0}),
      hours_per_month:
        Enum.into(@names, %{}, fn name ->
          {name, Enum.into(DateHelper.months_list(), %{}, &{&1, 0})}
        end),
      hours_per_year:
        Enum.into(@names, %{}, fn name ->
          {name, Enum.into(DateHelper.years_list(), %{}, &{&1, 0})}
        end)
    }
  end

  defp build_report([name, hours, _, month, year], %{
         all_hours: all_hours,
         hours_per_month: hours_per_month,
         hours_per_year: hours_per_year
       }) do
    all_hours = Map.put(all_hours, name, all_hours[name] + hours)

    hours_per_month_name =
      Map.put(hours_per_month[name], month, hours_per_month[name][month] + hours)

    hours_per_month = Map.put(hours_per_month, name, hours_per_month_name)
    hours_per_year_name = Map.put(hours_per_year[name], year, hours_per_year[name][year] + hours)
    hours_per_year = Map.put(hours_per_year, name, hours_per_year_name)

    %{all_hours: all_hours, hours_per_month: hours_per_month, hours_per_year: hours_per_year}
  end
end

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

  def build_with_many(filenames) do
    filenames
    |> Task.async_stream(&build/1)
    |> Enum.reduce(report_acc(), fn {:ok, result}, report ->
      merge_results(result, report)
    end)
  end

  defp merge_results(
         %{
           "all_hours" => all_hours1,
           "hours_per_month" => hours_per_month1,
           "hours_per_year" => hours_per_year1
         },
         %{
           "all_hours" => all_hours2,
           "hours_per_month" => hours_per_month2,
           "hours_per_year" => hours_per_year2
         }
       ) do
    all_hours = merge_maps(all_hours1, all_hours2)

    hours_per_month = merge_nested_maps(hours_per_month1, hours_per_month2)

    hours_per_year = merge_nested_maps(hours_per_year1, hours_per_year2)

    build_report_map(all_hours, hours_per_month, hours_per_year)
  end

  defp merge_maps(map1, map2) do
    Map.merge(map1, map2, fn _, value1, value2 -> value1 + value2 end)
  end

  defp merge_nested_maps(map1, map2) do
    Map.merge(map1, map2, fn _, value1, value2 ->
      merge_maps(value1, value2)
    end)
  end

  defp build_report([name, hours, _, month, year], %{
         "all_hours" => all_hours,
         "hours_per_month" => hours_per_month,
         "hours_per_year" => hours_per_year
       }) do
    all_hours = Map.put(all_hours, name, all_hours[name] + hours)

    hours_per_month = update_submap(hours_per_month, name, month, hours)
    hours_per_year = update_submap(hours_per_year, name, year, hours)

    build_report_map(all_hours, hours_per_month, hours_per_year)
  end

  defp build_report_map(all_hours, hours_per_month, hours_per_year) do
    %{
      "all_hours" => all_hours,
      "hours_per_month" => hours_per_month,
      "hours_per_year" => hours_per_year
    }
  end

  defp update_submap(map, key, subkey, value) do
    submap = Map.put(map[key], subkey, map[key][subkey] + value)
    Map.put(map, key, submap)
  end

  defp report_acc do
    all_hours = build_map_from_list(@names, 0)

    all_months = build_map_from_list(DateHelper.months_list(), 0)
    hours_per_month = build_map_from_list(@names, all_months)

    all_years = build_map_from_list(DateHelper.years_list(), 0)
    hours_per_year = build_map_from_list(@names, all_years)

    build_report_map(all_hours, hours_per_month, hours_per_year)
  end

  defp build_map_from_list(list, value) do
    Enum.into(list, %{}, &{&1, value})
  end
end

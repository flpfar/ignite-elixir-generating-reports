defmodule GenReport.Parser do
  alias GenReport.DateHelper

  def parse_file(filename) do
    filename
    |> File.stream!()
    |> Stream.map(& parse_line/1)
  end

  defp parse_line(line) do
    line
    |> String.trim()
    |> String.split(",")
    |> List.update_at(0, & String.downcase(&1))
    |> element_to_integer(1)
    |> element_to_integer(2)
    |> element_to_integer(4)
    |> translate_month()
  end

  defp element_to_integer(list, position) do
    List.update_at(list, position, & String.to_integer/1)
  end

  defp translate_month(line) do
    List.update_at(line, 3, & DateHelper.month_name/1)
  end
end

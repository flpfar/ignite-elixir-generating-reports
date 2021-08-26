defmodule GenReport.Parser do
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
    List.update_at(line, 3, & month_name/1)
  end

  defp month_name(month_number) do
    month_names = %{
      "1" => "janeiro",
      "2" => "fevereiro",
      "3" => "março",
      "4" => "abril",
      "5" => "maio",
      "6" => "junho",
      "7" => "julho",
      "8" => "agosto",
      "9" => "setembro",
      "10" => "outubro",
      "11" => "novembro",
      "12" => "dezembro",
    }

    month_names[month_number]
  end
end

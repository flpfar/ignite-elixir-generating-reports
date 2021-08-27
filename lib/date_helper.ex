defmodule GenReport.DateHelper do
  @months [
    "janeiro",
    "fevereiro",
    "março",
    "abril",
    "maio",
    "junho",
    "julho",
    "agosto",
    "setembro",
    "outubro",
    "novembro",
    "dezembro"
  ]

  @years [2016, 2017, 2018, 2019, 2020]

  def months_list, do: @months

  def years_list, do: @years

  def month_name(month_number) when is_binary(month_number), do: month_name(String.to_integer(month_number))

  def month_name(month_number), do: Enum.at(@months, month_number - 1)
end

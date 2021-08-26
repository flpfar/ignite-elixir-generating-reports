defmodule GenReport.Months do
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

  def months_list, do: @months

  def month_name(month_number) when is_binary(month_number), do: month_name(String.to_integer(month_number))

  def month_name(month_number), do: Enum.at(@months, month_number - 1)
end

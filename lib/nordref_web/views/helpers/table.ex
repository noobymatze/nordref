defmodule NordrefWeb.View.Helpers.Table do
  import Phoenix.HTML.Tag

  def list_table(list, columns, opts \\ []) do
    headers = columns |> Enum.map(fn c -> Keyword.get(c, :name) end)

    content_tag(:table, opts) do
      [
        content_tag(:thead) do
          content_tag(:tr) do
            Enum.map(headers, fn h -> content_tag(:th, h, []) end)
          end
        end,
        content_tag(:tbody) do
          Enum.map(list, fn d ->
            content_tag(:tr) do
              Enum.map(columns, fn c ->
                content_tag(:td) do
                  Keyword.get(c, :populate).(d)
                end
              end)
            end
          end)
        end
      ]
    end
  end

  def column(name, populate) do
    [name: name, populate: populate]
  end
end

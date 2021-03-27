defmodule NordrefWeb.UserView do
  use NordrefWeb, :view
  import NordrefWeb.View.Helpers.Table

  def license_table(licenses) do
    columns = [
      column("Saison", fn l -> l.season end),
      column("Lizenz", fn l -> l.type end),
      column("Lizenznummer", fn l -> l.number end)
    ]

    list_table(licenses, columns, class: "table table-striped")
  end
end

defmodule NordrefWeb.AdministrationController do
  use NordrefWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end

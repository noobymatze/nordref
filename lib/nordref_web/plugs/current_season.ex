defmodule NordrefWeb.Plugs.CurrentSeason do
  import Plug.Conn
  import Phoenix.Controller
  alias Nordref.Seasons

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    assign(conn, :current_season, Seasons.current_season())
  end
end

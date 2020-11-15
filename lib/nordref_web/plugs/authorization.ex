defmodule NordrefWeb.Plugs.Authorization do
  import Plug.Conn
  import Phoenix.Controller
  alias Nordref.Permissions

  def init(opts) do
    opts
  end

  def call(conn, opts) do
    action = action_name(conn)
    permission = opts[action]
    current_user = conn.assigns[:current_user]

    if Permissions.has_permission?(current_user, permission) do
      conn
    else
      conn
      |> put_status(:forbidden)
      |> put_view(NordrefWeb.ErrorView)
      |> render(:"403")
    end
  end
end

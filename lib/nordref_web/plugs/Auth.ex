defmodule NordrefWeb.Plugs.Auth do
  import Plug.Conn
  import Phoenix.Controller
  alias NordrefWeb.Router.Helpers, as: Routes
  alias Nordref.Users

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    case get_session(conn, :current_user_id) do
      nil ->
        conn
        |> redirect(to: Routes.session_path(conn, :login))
        |> halt()

      user_id ->
        user = Users.get_user!(user_id)

        conn
        |> assign(:current_user, user)
    end
  end
end

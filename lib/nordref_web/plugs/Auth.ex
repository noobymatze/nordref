defmodule NordrefWeb.Plugs.Auth do
  import Plug.Conn
  import Phoenix.Controller
  alias NordrefWeb.Router.Helpers, as: Routes
  alias Nordref.Users
  alias Nordref.Users.User

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    case get_session(conn, :current_user_id) do
      nil ->
        conn |> redirect_to_login()

      user_id ->
        with %User{} = user <- Users.get_by_id(user_id) do
          conn
          |> assign(:current_user, user)
        else
          _ ->
            conn
            |> redirect_to_login()
        end
    end
  end

  defp redirect_to_login(conn) do
    conn
    |> redirect(to: Routes.session_path(conn, :login))
    |> halt()
  end
end

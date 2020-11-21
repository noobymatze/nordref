defmodule NordrefWeb.SessionController do
  use NordrefWeb, :controller

  alias Nordref.Users
  alias Nordref.Users.Login

  def index(conn, _params) do
    changeset = Users.change_login(%Login{})
    render(conn, "login.html", changeset: changeset)
  end

  def login(conn, %{"login" => login_params}) do
    case Users.authenticate(login_params) do
      {:ok, user} ->
        conn
        |> put_session(:current_user_id, user.id)
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> render("login.html", changeset: changeset)

      {:error, {:invalid_username_or_password, changeset}} ->
        conn
        |> put_flash(:error, "Please check your username or password.")
        |> render("login.html", changeset: changeset)
    end
  end

  def logout(conn, _params) do
    conn
    |> put_session(:current_user_id, nil)
    |> redirect(to: "/login")
  end
end

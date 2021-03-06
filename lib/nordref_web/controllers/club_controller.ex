defmodule NordrefWeb.ClubController do
  use NordrefWeb, :controller

  import Plug.Conn
  alias Nordref.Clubs
  alias Nordref.Clubs.Club
  alias Nordref.Associations

  def index(conn, _params) do
    clubs = Clubs.list_clubs()
    associations = association_map()

    render(conn, "index.html", clubs: clubs, associations: associations)
  end

  def new(conn, _params) do
    changeset = Clubs.change_club(%Club{})
    associations = association_options()

    conn
    |> assign(:associations, associations)
    |> assign(:changeset, changeset)
    |> render("new.html")
  end

  def create(conn, %{"club" => club_params}) do
    case Clubs.create_club(club_params) do
      {:ok, club} ->
        conn
        |> put_flash(:info, "Club created successfully.")
        |> redirect(to: Routes.club_path(conn, :show, club))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html",
          changeset: changeset,
          associations: association_options()
        )
    end
  end

  def show(conn, %{"id" => id}) do
    club = Clubs.get_club!(id)
    associations = association_map()
    render(conn, "show.html", club: club, associations: associations)
  end

  def edit(conn, %{"id" => id}) do
    club = Clubs.get_club!(id)
    changeset = Clubs.change_club(club)
    associations = association_options()

    conn
    |> assign(:associations, associations)
    |> assign(:changeset, changeset)
    |> assign(:club, club)
    |> render("edit.html")
  end

  def update(conn, %{"id" => id, "club" => club_params}) do
    club = Clubs.get_club!(id)

    case Clubs.update_club(club, club_params) do
      {:ok, club} ->
        conn
        |> put_flash(:info, "Club updated successfully.")
        |> redirect(to: Routes.club_path(conn, :show, club))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(
          conn,
          "edit.html",
          club: club,
          changeset: changeset,
          associations: association_options()
        )
    end
  end

  def delete(conn, %{"id" => id}) do
    club = Clubs.get_club!(id)
    {:ok, _club} = Clubs.delete_club(club)

    conn
    |> put_flash(:info, "Club deleted successfully.")
    |> redirect(to: Routes.club_path(conn, :index))
  end

  defp association_map do
    Associations.list_associations()
    |> Enum.reduce(%{}, fn ra, acc -> Map.put(acc, ra.id, ra.name) end)
  end

  defp association_options do
    Associations.list_associations()
    |> Enum.reduce(%{}, fn ra, acc -> Map.put(acc, ra.name, ra.id) end)
  end
end

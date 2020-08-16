defmodule NordrefWeb.AssociationController do
  use NordrefWeb, :controller

  alias Nordref.Associations
  alias Nordref.Associations.Association

  alias Nordref.Users

  def index(conn, _params) do
    associations = Associations.list_associations()
    render(conn, "index.html", associations: associations)
  end

  def new(conn, _params) do
    changeset = Associations.change_association(%Association{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"association" => association_params}) do
    case Associations.create_association(association_params) do
      {:ok, association} ->
        conn
        |> put_flash(:info, "Association created successfully.")
        |> redirect(to: Routes.association_path(conn, :show, association))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    association = Associations.get_association!(id)
    users = Users.list_admins_and_instructors(id)

    instructors = users |> Enum.filter(fn usr -> usr.role == "INSTRUCTOR" end)

    # instructor_mails = instructors |> Enum.filter(fn usr -> usr.email != nil end) |> Enum.map( fn usr -> usr.email end) |> Enum.join(",")

    administrators = users |> Enum.filter(fn usr -> usr.role == "ADMIN" end)

    # administrator_mails = administrators |> Enum.filter(fn usr -> usr.email != nil end) |> Enum.map( fn usr -> usr.email end) |> Enum.join(",")

    user_mails =
      users
      |> Enum.filter(fn usr -> usr.email != nil end)
      |> Enum.map(fn usr -> usr.email end)
      |> Enum.join(",")

    # ,instructor_mails: instructor_mails, administrator_mails: administrator_mails )
    render(conn, "show.html",
      association: association,
      instructors: instructors,
      administrators: administrators,
      user_mails: user_mails
    )
  end

  def edit(conn, %{"id" => id}) do
    association = Associations.get_association!(id)
    changeset = Associations.change_association(association)
    render(conn, "edit.html", association: association, changeset: changeset)
  end

  def update(conn, %{"id" => id, "association" => association_params}) do
    association = Associations.get_association!(id)

    case Associations.update_association(association, association_params) do
      {:ok, association} ->
        conn
        |> put_flash(:info, "Association updated successfully.")
        |> redirect(to: Routes.association_path(conn, :show, association))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", association: association, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    association = Associations.get_association!(id)
    {:ok, _association} = Associations.delete_association(association)

    conn
    |> put_flash(:info, "Association deleted successfully.")
    |> redirect(to: Routes.association_path(conn, :index))
  end
end

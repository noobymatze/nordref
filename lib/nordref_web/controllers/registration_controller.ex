defmodule NordrefWeb.RegistrationController do
  use NordrefWeb, :controller

  alias Nordref.Registrations
  alias Nordref.Registrations.Registration

  alias Nordref.Licenses
  alias Nordref.Licenses.License

  alias Nordref.Courses

  def index(conn, _params) do
    registrations = Registrations.list_registrations()
    render(conn, "index.html", registrations: registrations)
  end

  def new(conn, _params) do
    changeset = Registrations.create_registration(%Registration{})
    render(conn, "new.html", changeset: changeset, course_select: Courses.list_courses())
  end

  def create(conn, %{"license" => license_params}) do
    case Licenses.create_license(license_params) do
      {:ok, license} ->
        conn
        |> put_flash(:info, "License created successfully.")
        |> redirect(to: Routes.license_path(conn, :show, license))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, license_types: License.types())
    end
  end

  #def show(conn, %{"id" => id}) do
    #registration = Registrations.get_registration!(id)
    #render(conn, "show.html", registration: registration)
  #end

  #def edit(conn, %{"id" => id}) do
    #license = Licenses.get_license!(id)
    #changeset = Licenses.change_license(license)

    #render(conn, "edit.html",
     # license: license,
      #changeset: changeset,
      #license_types: License.types()
    #)
  #end

  def update(conn, %{"id" => id, "license" => license_params}) do
    license = Licenses.get_license!(id)

    case Licenses.update_license(license, license_params) do
      {:ok, license} ->
        conn
        |> put_flash(:info, "License updated successfully.")
        |> redirect(to: Routes.license_path(conn, :show, license))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html",
          license: license,
          changeset: changeset,
          license_types: License.types()
        )
    end
  end

  def delete(conn, %{"id" => id}) do
    registration = Registrations.get_registration!(id)
    {:ok, _registration} = Registrations.delete_registration(registration)

    conn
    |> put_flash(:info, "Registration deleted successfully.")
    |> redirect(to: Routes.registration_path(conn, :index))
  end
end

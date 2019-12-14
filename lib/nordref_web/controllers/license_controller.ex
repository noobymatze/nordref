defmodule NordrefWeb.LicenseController do
  use NordrefWeb, :controller

  alias Nordref.Licenses
  alias Nordref.Licenses.License

  def index(conn, _params) do
    licenses = Licenses.list_licenses()
    render(conn, "index.html", licenses: licenses)
  end

  def new(conn, _params) do
    changeset = Licenses.change_license(%License{})
    render(conn, "new.html", changeset: changeset, license_types: License.types())
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

  def show(conn, %{"id" => id}) do
    license = Licenses.get_license!(id)
    render(conn, "show.html", license: license)
  end

  def edit(conn, %{"id" => id}) do
    license = Licenses.get_license!(id)
    changeset = Licenses.change_license(license)

    render(conn, "edit.html",
      license: license,
      changeset: changeset,
      license_types: License.types()
    )
  end

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
    license = Licenses.get_license!(id)
    {:ok, _license} = Licenses.delete_license(license)

    conn
    |> put_flash(:info, "License deleted successfully.")
    |> redirect(to: Routes.license_path(conn, :index))
  end
end

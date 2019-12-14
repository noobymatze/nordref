defmodule NordrefWeb.LicenseControllerTest do
  use NordrefWeb.ConnCase

  alias Nordref.Licenses

  @create_attrs %{
    first_name: "some first_name",
    last_name: "some last_name",
    license_number: 42,
    license_type: "L2",
    season: 42,
    year_of_birth: 42
  }
  @update_attrs %{
    first_name: "some updated first_name",
    last_name: "some updated last_name",
    license_number: 43,
    license_type: "LJ",
    season: 43,
    year_of_birth: 43
  }
  @invalid_attrs %{
    first_name: nil,
    last_name: nil,
    license_number: nil,
    license_type: nil,
    season: nil,
    year_of_birth: nil
  }

  def fixture(:license) do
    {:ok, license} = Licenses.create_license(@create_attrs)
    license
  end

  describe "index" do
    test "lists all licenses", %{conn: conn} do
      conn = get(conn, Routes.license_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Licenses"
    end
  end

  describe "new license" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.license_path(conn, :new))
      assert html_response(conn, 200) =~ "New License"
    end
  end

  describe "create license" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.license_path(conn, :create), license: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.license_path(conn, :show, id)

      conn = get(conn, Routes.license_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show License"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.license_path(conn, :create), license: @invalid_attrs)
      assert html_response(conn, 200) =~ "New License"
    end
  end

  describe "edit license" do
    setup [:create_license]

    test "renders form for editing chosen license", %{conn: conn, license: license} do
      conn = get(conn, Routes.license_path(conn, :edit, license))
      assert html_response(conn, 200) =~ "Edit License"
    end
  end

  describe "update license" do
    setup [:create_license]

    test "redirects when data is valid", %{conn: conn, license: license} do
      conn = put(conn, Routes.license_path(conn, :update, license), license: @update_attrs)
      assert redirected_to(conn) == Routes.license_path(conn, :show, license)

      conn = get(conn, Routes.license_path(conn, :show, license))
      assert html_response(conn, 200) =~ "some updated first_name"
    end

    test "renders errors when data is invalid", %{conn: conn, license: license} do
      conn = put(conn, Routes.license_path(conn, :update, license), license: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit License"
    end
  end

  describe "delete license" do
    setup [:create_license]

    test "deletes chosen license", %{conn: conn, license: license} do
      conn = delete(conn, Routes.license_path(conn, :delete, license))
      assert redirected_to(conn) == Routes.license_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.license_path(conn, :show, license))
      end
    end
  end

  defp create_license(_) do
    license = fixture(:license)
    {:ok, license: license}
  end
end

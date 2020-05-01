defmodule NordrefWeb.LicenseControllerTest do
  use NordrefWeb.ConnCase

  alias Nordref.Licenses
  alias Nordref.Seasons
  alias Nordref.Associations
  alias Nordref.Users
  alias Nordref.Clubs

  @create_attrs %{
    number: 42,
    type: "L2",
    season: 100,
    user_id: 0
  }
  @update_attrs %{
    number: 43,
    type: "LJ",
    season: 101,
    user_id: 0
  }
  @invalid_attrs %{
    number: nil,
    type: nil,
    season: nil,
    user_id: nil
  }

  def season_fixture(attrs \\ %{}) do
    {:ok, season} =
      attrs
      |> Enum.into(%{
        end: ~N[2010-04-17 14:00:00],
        end_registration: ~N[2010-04-17 14:00:00],
        start: ~N[2010-04-17 14:00:00],
        start_registration: ~N[2010-04-17 14:00:00],
        year: 100
      })
      |> Seasons.create_season()

    season
  end

  def association_fixture(attrs \\ %{}) do
    {:ok, association} =
      attrs
      |> Enum.into(%{name: "Bla"})
      |> Associations.create_association()

    association
  end

  def club_fixture(attrs \\ %{}) do
    association = association_fixture()

    {:ok, club} =
      attrs
      |> Enum.into(%{name: "Bla", short_name: "Test", association_id: association.id})
      |> Clubs.create_club()

    club
  end

  def user_fixture(attrs \\ %{}) do
    club = club_fixture()

    {:ok, user} =
      attrs
      |> Enum.into(%{
        birthday: ~D[2010-04-17],
        email: "some email",
        first_name: "some first_name",
        last_name: "some last_name",
        mobile: "some mobile",
        password: "some password",
        phone: "some phone",
        role: "SUPER_ADMIN",
        username: "some username",
        club_id: club.id
      })
      |> Users.create_user()

    user
  end

  def fixture(:license) do
    user = user_fixture()
    {:ok, license} = Licenses.create_license(%{@create_attrs | user_id: user.id})
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
      season = season_fixture(%{year: 102})
      user = user_fixture()

      conn =
        post(conn, Routes.license_path(conn, :create),
          license: %{@create_attrs | user_id: user.id, season: season.year}
        )

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.license_path(conn, :show, id)

      conn = get(conn, Routes.license_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show License"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      season = season_fixture(%{year: 103})
      user = user_fixture()

      conn =
        post(conn, Routes.license_path(conn, :create),
          license: %{@invalid_attrs | user_id: user.id, season: season.year}
        )

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
      season = season_fixture(%{year: 101})

      conn =
        put(conn, Routes.license_path(conn, :update, license),
          license: %{@update_attrs | user_id: license.user_id, season: season.year}
        )

      assert redirected_to(conn) == Routes.license_path(conn, :show, license)

      conn = get(conn, Routes.license_path(conn, :show, license))
      assert html_response(conn, 200) =~ "101"
    end

    test "renders errors when data is invalid", %{conn: conn, license: license} do
      conn =
        put(conn, Routes.license_path(conn, :update, license),
          license: %{@invalid_attrs | user_id: license.user_id}
        )

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
    season_fixture()
    season_fixture(%{year: 43})
    license = fixture(:license)
    {:ok, license: license}
  end
end

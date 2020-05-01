defmodule NordrefWeb.ClubControllerTest do
  use NordrefWeb.ConnCase

  alias Nordref.RegionalAssociations
  alias Nordref.Clubs

  @create_attrs %{
    name: "some name",
    regional_association_id: "FVN",
    short_name: "some short"
  }
  @update_attrs %{
    name: "some updated name",
    regional_association_id: "FLV",
    short_name: "updated"
  }
  @invalid_attrs %{name: nil, regional_association_id: nil, short_name: nil}

  def regional_association_fixture(attrs \\ %{}) do
    {:ok, regional_association} =
      attrs
      |> Enum.into(%{name: "Bla"})
      |> RegionalAssociations.create_regional_association()

    regional_association
  end

  def fixture(:club) do
    association = regional_association_fixture()
    {:ok, club} = Clubs.create_club(%{@create_attrs | regional_association_id: association.id})
    club
  end

  describe "index" do
    test "lists all clubs", %{conn: conn} do
      conn = get(conn, Routes.club_path(conn, :index))
      assert html_response(conn, 200) =~ "Clubs"
    end
  end

  describe "new club" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.club_path(conn, :new))
      assert html_response(conn, 200) =~ "New Club"
    end
  end

  describe "create club" do
    test "redirects to show when data is valid", %{conn: conn} do
      association = regional_association_fixture()
      conn = post(conn, Routes.club_path(conn, :create), club: %{ @create_attrs | regional_association_id: association.id})

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.club_path(conn, :show, id)

      conn = get(conn, Routes.club_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Club"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      association = regional_association_fixture()
      conn = post(conn, Routes.club_path(conn, :create), club: %{ @invalid_attrs | regional_association_id: association.id })
      assert html_response(conn, 200) =~ "New Club"
    end
  end

  describe "edit club" do
    setup [:create_club]

    test "renders form for editing chosen club", %{conn: conn, club: club} do
      conn = get(conn, Routes.club_path(conn, :edit, club))
      assert html_response(conn, 200) =~ "Edit Club"
    end
  end

  describe "update club" do
    setup [:create_club]

    test "redirects when data is valid", %{conn: conn, club: club} do
      conn = put(conn, Routes.club_path(conn, :update, club), club: %{@update_attrs | regional_association_id: club.regional_association_id})
      assert redirected_to(conn) == Routes.club_path(conn, :show, club)

      conn = get(conn, Routes.club_path(conn, :show, club))
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, club: club} do
      conn = put(conn, Routes.club_path(conn, :update, club), club: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Club"
    end
  end

  describe "delete club" do
    setup [:create_club]

    test "deletes chosen club", %{conn: conn, club: club} do
      conn = delete(conn, Routes.club_path(conn, :delete, club))
      assert redirected_to(conn) == Routes.club_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.club_path(conn, :show, club))
      end
    end
  end

  defp create_club(_) do
    club = fixture(:club)
    {:ok, club: club}
  end
end

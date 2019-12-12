defmodule NordrefWeb.ClubControllerTest do
  use NordrefWeb.ConnCase

  alias Nordref.Clubs

  @create_attrs %{name: "some name", regional_association: "some regional_association", short_name: "some short_name"}
  @update_attrs %{name: "some updated name", regional_association: "some updated regional_association", short_name: "some updated short_name"}
  @invalid_attrs %{name: nil, regional_association: nil, short_name: nil}

  def fixture(:club) do
    {:ok, club} = Clubs.create_club(@create_attrs)
    club
  end

  describe "index" do
    test "lists all clubs", %{conn: conn} do
      conn = get(conn, Routes.club_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Clubs"
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
      conn = post(conn, Routes.club_path(conn, :create), club: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.club_path(conn, :show, id)

      conn = get(conn, Routes.club_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Club"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.club_path(conn, :create), club: @invalid_attrs)
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
      conn = put(conn, Routes.club_path(conn, :update, club), club: @update_attrs)
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

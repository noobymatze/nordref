defmodule NordrefWeb.UserControllerTest do
  use NordrefWeb.ConnCase

  alias Nordref.Users
  alias Nordref.Clubs
  alias Nordref.RegionalAssociations

  @create_attrs %{
    birthday: ~D[2010-04-17],
    email: "some email",
    first_name: "some first_name",
    last_name: "some last_name",
    mobile: "some mobile",
    password: "some password",
    phone: "some phone",
    role: "SUPER_ADMIN",
    username: "some username",
    club_id: 1
  }
  @update_attrs %{
    birthday: ~D[2011-05-18],
    email: "some updated email",
    first_name: "some updated first_name",
    last_name: "some updated last_name",
    mobile: "some updated mobile",
    password: "some updated password",
    phone: "some updated phone",
    role: "ADMIN",
    username: "some updated username",
    club_id: 1
  }
  @invalid_attrs %{
    birthday: nil,
    email: nil,
    first_name: nil,
    last_name: nil,
    mobile: nil,
    password: nil,
    phone: nil,
    role: nil,
    username: nil,
    club_id: 0
  }

  def regional_association_fixture(attrs \\ %{}) do
    {:ok, regional_association} =
      attrs
      |> Enum.into(%{name: "Bla"})
      |> RegionalAssociations.create_regional_association()

    regional_association
  end

  def club_fixture(attrs \\ %{}) do
    association = regional_association_fixture()
    {:ok, club} =
      attrs
      |> Enum.into(%{name: "some name", short_name: "T", regional_association_id: association.id})
      |> Clubs.create_club()

    club
  end

  def fixture(:user) do
    club = club_fixture()
    {:ok, user} = Users.create_user(%{ @create_attrs | club_id: club.id})
    user
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Users"
    end
  end

  describe "new user" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :new))
      assert html_response(conn, 200) =~ "New User"
    end
  end

  describe "create user" do
    test "redirects to show when data is valid", %{conn: conn} do
      club = club_fixture()
      conn = post(conn, Routes.user_path(conn, :create), user: %{@create_attrs | club_id: club.id})

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.user_path(conn, :show, id)

      conn = get(conn, Routes.user_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show User"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      club = club_fixture()
      conn = post(conn, Routes.user_path(conn, :create), user: %{@invalid_attrs | club_id: club.id})
      assert html_response(conn, 200) =~ "New User"
    end
  end

  describe "edit user" do
    setup [:create_user]

    test "renders form for editing chosen user", %{conn: conn, user: user} do
      conn = get(conn, Routes.user_path(conn, :edit, user))
      assert html_response(conn, 200) =~ "Edit User"
    end
  end

  describe "update user" do
    setup [:create_user]

    test "redirects when data is valid", %{conn: conn, user: user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: %{ @update_attrs | club_id: user.club_id})
      assert redirected_to(conn) == Routes.user_path(conn, :show, user)

      conn = get(conn, Routes.user_path(conn, :show, user))
      assert html_response(conn, 200) =~ "some updated email"
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: %{ @invalid_attrs | club_id: user.club_id})
      assert html_response(conn, 200) =~ "Edit User"
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, Routes.user_path(conn, :delete, user))
      assert redirected_to(conn) == Routes.user_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.user_path(conn, :show, user))
      end
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end

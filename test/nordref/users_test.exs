defmodule Nordref.UsersTest do
  use Nordref.DataCase

  alias Nordref.Users
  alias Nordref.Associations
  alias Nordref.Clubs

  describe "users" do
    alias Nordref.Users.User

    @valid_attrs %{
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
      club_id: nil
    }

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
        |> Enum.into(%{@valid_attrs | club_id: club.id})
        |> Users.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      all_users = Users.list_users()
      assert Enum.any?(all_users, fn u -> u == user end)
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Users.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      club = club_fixture()
      assert {:ok, %User{} = user} = Users.create_user(%{@valid_attrs | club_id: club.id})
      assert user.birthday == ~D[2010-04-17]
      assert user.email == "some email"
      assert user.first_name == "some first_name"
      assert user.last_name == "some last_name"
      assert user.mobile == "some mobile"
      assert user.password == "some password"
      assert user.phone == "some phone"
      assert user.role == "SUPER_ADMIN"
      assert user.username == "some username"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Users.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()

      assert {:ok, %User{} = user} =
               Users.update_user(user, %{@update_attrs | club_id: user.club_id})

      assert user.birthday == ~D[2011-05-18]
      assert user.email == "some updated email"
      assert user.first_name == "some updated first_name"
      assert user.last_name == "some updated last_name"
      assert user.mobile == "some updated mobile"
      assert user.password == "some updated password"
      assert user.phone == "some updated phone"
      assert user.role == "ADMIN"
      assert user.username == "some updated username"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Users.update_user(user, @invalid_attrs)
      assert user == Users.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Users.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Users.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Users.change_user(user)
    end

    test "get_by_username/1 returns a user" do
      user = user_fixture(%{username: "tester"})
      assert user == Users.get_by_username(user.username)
    end

    test "get_by_username/1 returns nil without user" do
      assert nil == Users.get_by_username("tester")
    end
  end
end

defmodule Nordref.ClubsTest do
  use Nordref.DataCase

  alias Nordref.Clubs
  alias Nordref.Associations

  describe "clubs" do
    alias Nordref.Clubs.Club

    @valid_attrs %{
      name: "some name",
      association_id: 0,
      short_name: "some short"
    }
    @update_attrs %{
      name: "some updated name",
      association_id: 0,
      short_name: "updated"
    }
    @invalid_attrs %{name: nil, association_id: nil, short_name: nil}

    def association_fixture(attrs \\ %{}) do
      {:ok, association} =
        attrs
        |> Enum.into(%{name: "Bla"})
        |> Associations.create_association()

      association
    end

    def club_fixture(attrs \\ %{}) do
      {:ok, club} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Clubs.create_club()

      club
    end

    test "list_clubs/0 returns all clubs" do
      association = association_fixture()
      club = club_fixture(%{association_id: association.id})
      assert Clubs.list_clubs() == [club]
    end

    test "get_club!/1 returns the club with given id" do
      association = association_fixture()
      club = club_fixture(%{association_id: association.id})
      assert Clubs.get_club!(club.id) == club
    end

    test "create_club/1 with valid data creates a club" do
      association = association_fixture()

      assert {:ok, %Club{} = club} =
               Clubs.create_club(%{@valid_attrs | association_id: association.id})

      assert club.name == "some name"
      assert club.association_id == association.id
      assert club.short_name == "some short"
    end

    test "create_club/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Clubs.create_club(@invalid_attrs)
    end

    test "update_club/2 with valid data updates the club" do
      association = association_fixture()
      club = club_fixture(%{association_id: association.id})

      assert {:ok, %Club{} = club} =
               Clubs.update_club(club, %{@update_attrs | association_id: association.id})

      assert club.name == "some updated name"
      assert club.association_id == association.id
      assert club.short_name == "updated"
    end

    test "update_club/2 with invalid data returns error changeset" do
      association = association_fixture()
      club = club_fixture(%{association_id: association.id})

      assert {:error, %Ecto.Changeset{}} =
               Clubs.update_club(club, %{@invalid_attrs | association_id: association.id})

      club2 = Clubs.get_club!(club.id)
      assert club == club2
    end

    test "delete_club/1 deletes the club" do
      association = association_fixture()
      club = club_fixture(%{association_id: association.id})
      assert {:ok, %Club{}} = Clubs.delete_club(club)
      assert_raise Ecto.NoResultsError, fn -> Clubs.get_club!(club.id) end
    end

    test "change_club/1 returns a club changeset" do
      association = association_fixture()
      club = club_fixture(%{association_id: association.id})
      assert %Ecto.Changeset{} = Clubs.change_club(club)
    end
  end
end

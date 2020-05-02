defmodule Nordref.AssociationsTest do
  use Nordref.DataCase

  alias Nordref.Associations

  describe "associations" do
    alias Nordref.Associations.Association

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def association_fixture(attrs \\ %{}) do
      {:ok, association} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Associations.create_association()

      association
    end

    test "list_associations/0 returns all associations" do
      association = association_fixture()
      assert Associations.list_associations() == [association]
    end

    test "get_association!/1 returns the association with given id" do
      association = association_fixture()
      assert Associations.get_association!(association.id) == association
    end

    test "create_association/1 with valid data creates a association" do
      assert {:ok, %Association{} = association} = Associations.create_association(@valid_attrs)
    end

    test "create_association/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Associations.create_association(@invalid_attrs)
    end

    test "update_association/2 with valid data updates the association" do
      association = association_fixture()
      assert {:ok, %Association{} = association} = Associations.update_association(association, @update_attrs)
    end

    test "update_association/2 with invalid data returns error changeset" do
      association = association_fixture()
      assert {:error, %Ecto.Changeset{}} = Associations.update_association(association, @invalid_attrs)
      assert association == Associations.get_association!(association.id)
    end

    test "delete_association/1 deletes the association" do
      association = association_fixture()
      assert {:ok, %Association{}} = Associations.delete_association(association)
      assert_raise Ecto.NoResultsError, fn -> Associations.get_association!(association.id) end
    end

    test "change_association/1 returns a association changeset" do
      association = association_fixture()
      assert %Ecto.Changeset{} = Associations.change_association(association)
    end
  end
end

defmodule Nordref.LicensesTest do
  use Nordref.DataCase

  alias Nordref.Licenses
  alias Nordref.Seasons

  describe "licenses" do
    alias Nordref.Licenses.License

    @valid_attrs %{
      number: 42,
      type: "LJ",
      season: 42,
      user_id: 0
    }
    @update_attrs %{
      number: 43,
      type: "L2",
      season: 43,
      user_id: 0
    }
    @invalid_attrs %{
      number: nil,
      type: nil,
      season: nil,
      user_id: nil
    }

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Users.create_user()

      user
    end

    def season_fixture(attrs \\ %{}) do
      {:ok, season} =
        attrs
        |> Enum.into(%{
          end: ~N[2010-04-17 14:00:00],
          end_registration: ~N[2010-04-17 14:00:00],
          start: ~N[2010-04-17 14:00:00],
          start_registration: ~N[2010-04-17 14:00:00],
          year: 42
        })
        |> Seasons.create_season()

      season
    end

    def license_fixture(attrs \\ %{}) do
      _season42 = season_fixture()
      _season43 = season_fixture(%{year: 43})

      {:ok, license} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Licenses.create_license()

      license
    end

    test "list_licenses/0 returns all licenses" do
      license = license_fixture()
      assert Licenses.list_licenses() == [license]
    end

    test "get_license!/1 returns the license with given id" do
      license = license_fixture()
      assert Licenses.get_license!(license.id) == license
    end

    test "create_license/1 with valid data creates a license" do
      season_fixture()
      assert {:ok, %License{} = license} = Licenses.create_license(@valid_attrs)
      assert license.number == 42
      assert license.type == "LJ"
      assert license.season == 42
    end

    test "create_license/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Licenses.create_license(@invalid_attrs)
    end

    test "update_license/2 with valid data updates the license" do
      license = license_fixture()
      assert {:ok, %License{} = license} = Licenses.update_license(license, @update_attrs)
      assert license.number == 43
      assert license.type == "L2"
      assert license.season == 43
    end

    test "update_license/2 with invalid data returns error changeset" do
      license = license_fixture()
      assert {:error, %Ecto.Changeset{}} = Licenses.update_license(license, @invalid_attrs)
      assert license == Licenses.get_license!(license.id)
    end

    test "delete_license/1 deletes the license" do
      license = license_fixture()
      assert {:ok, %License{}} = Licenses.delete_license(license)
      assert_raise Ecto.NoResultsError, fn -> Licenses.get_license!(license.id) end
    end

    test "change_license/1 returns a license changeset" do
      license = license_fixture()
      assert %Ecto.Changeset{} = Licenses.change_license(license)
    end
  end
end

defmodule Nordref.LicensesTest do
  use Nordref.DataCase

  alias Nordref.Licenses

  describe "licenses" do
    alias Nordref.Licenses.License

    @valid_attrs %{
      first_name: "some first_name",
      last_name: "some last_name",
      license_number: 42,
      license_type: "LJ",
      season: 42,
      year_of_birth: 42
    }
    @update_attrs %{
      first_name: "some updated first_name",
      last_name: "some updated last_name",
      license_number: 43,
      license_type: "L2",
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

    def license_fixture(attrs \\ %{}) do
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
      assert {:ok, %License{} = license} = Licenses.create_license(@valid_attrs)
      assert license.first_name == "some first_name"
      assert license.last_name == "some last_name"
      assert license.license_number == 42
      assert license.license_type == "LJ"
      assert license.season == 42
      assert license.year_of_birth == 42
    end

    test "create_license/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Licenses.create_license(@invalid_attrs)
    end

    test "update_license/2 with valid data updates the license" do
      license = license_fixture()
      assert {:ok, %License{} = license} = Licenses.update_license(license, @update_attrs)
      assert license.first_name == "some updated first_name"
      assert license.last_name == "some updated last_name"
      assert license.license_number == 43
      assert license.license_type == "L2"
      assert license.season == 43
      assert license.year_of_birth == 43
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

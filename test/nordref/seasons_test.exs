defmodule Nordref.SeasonsTest do
  use Nordref.DataCase

  alias Nordref.Seasons

  describe "seasons" do
    alias Nordref.Seasons.Season

    @valid_attrs %{
      end: ~N[2010-04-17 14:00:00],
      end_registration: ~N[2010-04-17 14:00:00],
      start: ~N[2010-04-17 14:00:00],
      start_registration: ~N[2010-04-17 14:00:00],
      year: 42
    }
    @update_attrs %{
      end: ~N[2011-05-18 15:01:01],
      end_registration: ~N[2011-05-18 15:01:01],
      start: ~N[2011-05-18 15:01:01],
      start_registration: ~N[2011-05-18 15:01:01],
      year: 43
    }
    @invalid_attrs %{
      end: nil,
      end_registration: nil,
      start: nil,
      start_registration: nil,
      year: nil
    }

    def season_fixture(attrs \\ %{}) do
      {:ok, season} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Seasons.create_season()

      season
    end

    test "list_seasons/0 returns all seasons" do
      _season = season_fixture()
      assert length(Seasons.list_seasons()) == 1
    end

    test "get_season!/1 returns the season with given id" do
      season = season_fixture()
      assert Seasons.get_season!(season.year) == season
    end

    test "create_season/1 with valid data creates a season" do
      assert {:ok, %Season{} = season} = Seasons.create_season(@valid_attrs)
      assert season.end == ~N[2010-04-17 14:00:00]
      assert season.end_registration == ~N[2010-04-17 14:00:00]
      assert season.start == ~N[2010-04-17 14:00:00]
      assert season.start_registration == ~N[2010-04-17 14:00:00]
      assert season.year == 42
    end

    test "create_season/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Seasons.create_season(@invalid_attrs)
    end

    test "update_season/2 with valid data updates the season" do
      season = season_fixture()
      assert {:ok, %Season{} = season} = Seasons.update_season(season, @update_attrs)
      assert season.end == ~N[2011-05-18 15:01:01]
      assert season.end_registration == ~N[2011-05-18 15:01:01]
      assert season.start == ~N[2011-05-18 15:01:01]
      assert season.start_registration == ~N[2011-05-18 15:01:01]
      assert season.year == 43
    end

    test "update_season/2 with invalid data returns error changeset" do
      season = season_fixture()
      assert {:error, %Ecto.Changeset{}} = Seasons.update_season(season, @invalid_attrs)
      assert season == Seasons.get_season!(season.year)
    end

    test "delete_season/1 deletes the season" do
      season = season_fixture()
      assert {:ok, %Season{}} = Seasons.delete_season(season)
      assert_raise Ecto.NoResultsError, fn -> Seasons.get_season!(season.year) end
    end

    test "change_season/1 returns a season changeset" do
      season = season_fixture()
      assert %Ecto.Changeset{} = Seasons.change_season(season)
    end
  end
end

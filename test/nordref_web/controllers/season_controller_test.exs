defmodule NordrefWeb.SeasonControllerTest do
  use NordrefWeb.ConnCase

  alias Nordref.Seasons

  @create_attrs %{
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
    year: 42
  }
  @invalid_attrs %{
    end: nil,
    end_registration: nil,
    start: nil,
    start_registration: nil,
    year: nil
  }

  def fixture(:season) do
    {:ok, season} = Seasons.create_season(@create_attrs)
    season
  end

  describe "index" do
    test "lists all seasons", %{conn: conn} do
      conn = get(conn, Routes.season_path(conn, :index))
      assert html_response(conn, 200) =~ "Saisons"
    end
  end

  describe "new season" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.season_path(conn, :new))
      assert html_response(conn, 200) =~ "New Season"
    end
  end

  describe "create season" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.season_path(conn, :create), season: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.season_path(conn, :show, id)

      conn = get(conn, Routes.season_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Season"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.season_path(conn, :create), season: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Season"
    end
  end

  describe "edit season" do
    setup [:create_season]

    test "renders form for editing chosen season", %{conn: conn, season: season} do
      conn = get(conn, Routes.season_path(conn, :edit, season))
      assert html_response(conn, 200) =~ "Edit Season"
    end
  end

  describe "update season" do
    setup [:create_season]

    test "redirects when data is valid", %{conn: conn, season: season} do
      conn = put(conn, Routes.season_path(conn, :update, season), season: @update_attrs)
      assert redirected_to(conn) == Routes.season_path(conn, :show, season)

      conn = get(conn, Routes.season_path(conn, :show, season))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, season: season} do
      conn = put(conn, Routes.season_path(conn, :update, season), season: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Season"
    end
  end

  describe "delete season" do
    setup [:create_season]

    test "deletes chosen season", %{conn: conn, season: season} do
      conn = delete(conn, Routes.season_path(conn, :delete, season))
      assert redirected_to(conn) == Routes.season_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.season_path(conn, :show, season))
      end
    end
  end

  defp create_season(_) do
    season = fixture(:season)
    {:ok, season: season}
  end
end

defmodule NordrefWeb.CourseControllerTest do
  use NordrefWeb.ConnCase

  alias Nordref.Courses
  alias Nordref.Seasons
  alias Nordref.Clubs
  alias Nordref.Associations
  alias Nordref.Users
  alias Nordref.Registrations

  @create_attrs %{
    date: ~N[2010-04-17 00:00:00],
    max_participants: 42,
    max_per_club: 42,
    name: "Test G2",
    max_organizer_participants: 42,
    released: true,
    type: "G2",
    organizer_id: 0,
    season: 0
  }
  @update_attrs %{
    date: ~N[2011-05-18 00:00:00],
    max_participants: 43,
    max_per_club: 43,
    name: "some updated name",
    max_organizer_participants: 43,
    released: false,
    type: "F",
    organizer_id: 0,
    season: 0
  }
  @invalid_attrs %{
    date: nil,
    max_participants: nil,
    max_per_club: nil,
    name: nil,
    max_organizer_participants: nil,
    released: nil,
    type: nil,
    organizer_id: nil,
    season: nil
  }

  def season_fixture(attrs \\ %{}) do
    {:ok, season} =
      attrs
      |> Enum.into(%{
        name: "Test",
        year: 2019,
        start: ~N[2011-05-18 00:00:00],
        end: ~N[2011-05-18 00:00:00]
      })
      |> Seasons.create_season()

    season
  end

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
      |> Enum.into(%{name: "some name", short_name: "T", association_id: association.id})
      |> Clubs.create_club()

    club
  end

  def user_fixture(club) do
    create_attrs = %{
      birthday: ~D[2010-04-17],
      email: "some email",
      first_name: "some first_name",
      last_name: "some last_name",
      mobile: "some mobile",
      password: "some password",
      phone: "some phone",
      role: "SUPER_ADMIN",
      username: "some username",
      club_id: club.id
    }

    {:ok, user} = Users.create_user(create_attrs)
    user
  end

  def fixture(:course) do
    season = season_fixture()
    club = club_fixture()

    {:ok, course} =
      Courses.create_course(%{@create_attrs | organizer_id: club.id, season: season.year})

    course
  end

  describe "index" do
    test "lists all courses", %{conn: conn} do
      conn = get(conn, Routes.course_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Courses"
    end
  end

  describe "new course" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.course_path(conn, :new))
      assert html_response(conn, 200) =~ "New Course"
    end
  end

  describe "create course" do
    test "redirects to show when data is valid", %{conn: conn} do
      season = season_fixture()
      club = club_fixture()

      conn =
        post(conn, Routes.course_path(conn, :create),
          course: %{@create_attrs | organizer_id: club.id, season: season.year}
        )

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.course_path(conn, :show, id)

      conn = get(conn, Routes.course_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Course"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      season = season_fixture()
      club = club_fixture()

      conn =
        post(conn, Routes.course_path(conn, :create),
          course: %{@invalid_attrs | season: season.year, organizer_id: club.id}
        )

      assert html_response(conn, 200) =~ "New Course"
    end
  end

  describe "edit course" do
    setup [:create_course]

    test "renders form for editing chosen course", %{conn: conn, course: course} do
      conn = get(conn, Routes.course_path(conn, :edit, course))
      assert html_response(conn, 200) =~ "Edit Course"
    end
  end

  describe "update course" do
    setup [:create_course]

    test "redirects when data is valid", %{conn: conn, course: course} do
      conn =
        put(conn, Routes.course_path(conn, :update, course),
          course: %{@update_attrs | organizer_id: course.organizer_id, season: course.season}
        )

      assert redirected_to(conn) == Routes.course_path(conn, :show, course)

      conn = get(conn, Routes.course_path(conn, :show, course))
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, course: course} do
      conn =
        put(conn, Routes.course_path(conn, :update, course),
          course: %{@invalid_attrs | organizer_id: course.organizer_id, season: course.season}
        )

      assert html_response(conn, 200) =~ "Edit Course"
    end
  end

  describe "delete course" do
    setup [:create_course]

    test "deletes chosen course", %{conn: conn, course: course} do
      conn = delete(conn, Routes.course_path(conn, :delete, course))
      assert redirected_to(conn) == Routes.course_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.course_path(conn, :show, course))
      end
    end
  end

  describe "register for course" do
    setup [:setup_registration]

    test "create registration", %{conn: conn, course: course, user: user} do
      conn =
        conn
        |> assign(:current_user, user)
        |> post(Routes.course_path(conn, :register, course.id))

      assert redirected_to(conn, 302) == Routes.course_path(conn, :registration)
    end

    test "redirect to register_g when a corresponding g course exists", %{conn: conn, course: course, user: user, club: club, season: season} do
      {:ok, _} =
        Courses.create_course(%{@create_attrs | name: "Test G3", organizer_id: club.id, season: season.year})

      conn =
        conn
        |> assign(:current_user, user)
        |> post(Routes.course_path(conn, :register, course.id))

      assert html_response(conn, 200) =~ "Nein"
      assert html_response(conn, 200) =~ "Ja"
    end

    test "save both registrations", %{conn: conn, course: course, user: user, club: club, season: season} do
      {:ok, corresponding_course} =
        Courses.create_course(%{@create_attrs | name: "Test G3", organizer_id: club.id, season: season.year})

      conn =
        conn
        |> assign(:current_user, user)
        |> post(Routes.course_path(conn, :register_g, course_id: course.id, corresponding_course_id: corresponding_course.id))

      registrations = Registrations.list_registrations()
      assert redirected_to(conn, 302) == Routes.course_path(conn, :registration)
      assert length(registrations) == 2
    end
  end

  defp create_course(_) do
    course = fixture(:course)
    {:ok, course: course}
  end

  defp setup_registration(_) do
    season = season_fixture()
    club = club_fixture()
    user = user_fixture(club)

    {:ok, course} =
      Courses.create_course(%{
        @create_attrs
        | max_participants: 20,
          max_per_club: 6,
          max_organizer_participants: 6,
          organizer_id: club.id,
          season: season.year
      })

    {:ok, season: season, club: club, user: user, course: course}
  end
end

defmodule Nordref.RegistrationsTest do
  use Nordref.DataCase

  alias Nordref.Seasons
  alias Nordref.Seasons.Season
  alias Nordref.Users
  alias Nordref.Associations
  alias Nordref.Clubs
  alias Nordref.Courses
  alias Nordref.Registrations
  alias Nordref.Registrations.Registration

  describe "registrations" do
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
        |> Enum.into(%{
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
        })
        |> Users.create_user()

      user
    end

    def course_fixture(%Season{} = season, attrs \\ %{}) do
      club = club_fixture()

      {:ok, course} =
        attrs
        |> Enum.into(%{
          date: ~N[2010-04-17 00:00:00],
          max_participants: 42,
          max_per_club: 42,
          name: "some name",
          max_organizer_participants: 42,
          released: true,
          type: "F",
          organizer_id: club.id,
          season: season.year
        })
        |> Courses.create_course()

      course
    end

    test "register/1 registers user successfully" do
      season = season_fixture()
      user = user_fixture()
      course = course_fixture(season)
      assert {:ok, %Registration{} = registration} = Registrations.register(user, course)
      assert user.id == registration.user_id
      assert course.id == registration.course_id
    end

    test "register/1 errors, if no seat is available anymore" do
      season = season_fixture()
      user = user_fixture()

      course =
        course_fixture(season, %{
          max_participants: 0
        })

      assert {:error, {:not_available, _}} = Registrations.register(user, course)
    end

    test "register/1 errors, if user tries to register for same course again" do
      season = season_fixture()
      user = user_fixture()

      course =
        course_fixture(season, %{
          max_participants: 2
        })

      assert {:ok, %Registration{} = registration} = Registrations.register(user, course)
      assert user.id == registration.user_id
      assert course.id == registration.course_id

      assert {:error, {:not_allowed, _}} = Registrations.register(user, course)
    end

    test "register/1 errors, if user tries to register for another F or J course" do
      season = season_fixture()
      user = user_fixture()

      course =
        course_fixture(season, %{
          max_participants: 2,
          season: season.year
        })

      course2 =
        course_fixture(season, %{
          max_participants: 2,
          season: season.year
        })

      assert {:ok, %Registration{} = registration} = Registrations.register(user, course)
      assert user.id == registration.user_id
      assert course.id == registration.course_id

      assert {:error, {:not_allowed, _}} = Registrations.register(user, course2)
    end

    test "register/1 ok, if user tries to register from organizer club" do
      season = season_fixture()

      course =
        course_fixture(season, %{
          max_participants: 0,
          max_organizer_participants: 1,
          season: season.year
        })

      user =
        user_fixture(%{
          club_id: course.organizer_id
        })

      assert {:ok, %Registration{} = registration} = Registrations.register(user, course)
      assert user.id == registration.user_id
      assert course.id == registration.course_id
    end
  end
end

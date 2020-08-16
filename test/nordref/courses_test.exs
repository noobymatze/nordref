defmodule Nordref.CoursesTest do
  use Nordref.DataCase

  alias Nordref.Courses
  alias Nordref.Clubs
  alias Nordref.Associations
  alias Nordref.Seasons

  describe "courses" do
    alias Nordref.Courses.Course

    @valid_attrs %{
      date: ~N[2010-04-17 00:00:00],
      max_participants: 42,
      max_per_club: 42,
      name: "some name",
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
      season: 0
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
        |> Enum.into(%{
          name: "some name",
          short_name: "T",
          association_id: association.id
        })
        |> Clubs.create_club()

      club
    end

    def course_fixture(attrs \\ %{}) do
      club = club_fixture()
      season = season_fixture()

      {:ok, course} =
        attrs
        |> Enum.into(
          @valid_attrs
          |> Map.replace!(:organizer_id, club.id)
          |> Map.replace!(:season, season.year)
        )
        |> Courses.create_course()

      course
    end

    test "list_courses/0 returns all courses" do
      course = course_fixture()
      assert Courses.list_courses() == [course]
    end

    test "get_course_by_name/1 returns the course" do
      course = course_fixture()
      assert Courses.get_course_by_name(course.name) == course
    end

    test "get_course_by_name/1 returns nil if no course exists" do
      assert Courses.get_course_by_name("Test") == nil
    end

    test "get_course!/1 returns the course with given id" do
      course = course_fixture()
      assert Courses.get_course!(course.id) == course
    end

    test "create_course/1 with valid data creates a course" do
      club = club_fixture()
      season = season_fixture()

      assert {:ok, %Course{} = course} =
               @valid_attrs
               |> Map.replace!(:organizer_id, club.id)
               |> Map.replace!(:season, season.year)
               |> Courses.create_course()

      assert course.date == ~N[2010-04-17 00:00:00]
      assert course.max_participants == 42
      assert course.max_per_club == 42
      assert course.name == "some name"
      assert course.max_organizer_participants == 42
      assert course.released == true
      assert course.type == "G2"
    end

    test "create_course/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Courses.create_course(@invalid_attrs)
    end

    test "update_course/2 with valid data updates the course" do
      course = course_fixture()

      assert {:ok, %Course{} = course} =
               Courses.update_course(course, %{
                 @update_attrs
                 | organizer_id: course.organizer_id,
                   season: course.season
               })

      assert course.date == ~N[2011-05-18 00:00:00]
      assert course.max_participants == 43
      assert course.max_per_club == 43
      assert course.name == "some updated name"
      assert course.max_organizer_participants == 43
      assert course.released == false
      assert course.type == "F"
    end

    test "update_course/2 with invalid data returns error changeset" do
      course = course_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Courses.update_course(course, %{
                 @invalid_attrs
                 | organizer_id: course.organizer_id,
                   season: course.season
               })

      assert course == Courses.get_course!(course.id)
    end

    test "delete_course/1 deletes the course" do
      course = course_fixture()
      assert {:ok, %Course{}} = Courses.delete_course(course)
      assert_raise Ecto.NoResultsError, fn -> Courses.get_course!(course.id) end
    end

    test "change_course/1 returns a course changeset" do
      course = course_fixture()
      assert %Ecto.Changeset{} = Courses.change_course(course)
    end
  end
end

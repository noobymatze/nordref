defmodule Nordref.CoursesTest do
  use Nordref.DataCase

  alias Nordref.Courses

  describe "courses" do
    alias Nordref.Courses.Course

    @valid_attrs %{
      date: ~D[2010-04-17],
      max_participants: 42,
      max_per_club: 42,
      name: "some name",
      organizer_participants: 42,
      released: true,
      type: "some type"
    }
    @update_attrs %{
      date: ~D[2011-05-18],
      max_participants: 43,
      max_per_club: 43,
      name: "some updated name",
      organizer_participants: 43,
      released: false,
      type: "some updated type"
    }
    @invalid_attrs %{
      date: nil,
      max_participants: nil,
      max_per_club: nil,
      name: nil,
      organizer_participants: nil,
      released: nil,
      type: nil
    }

    def course_fixture(attrs \\ %{}) do
      {:ok, course} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Courses.create_course()

      course
    end

    test "list_courses/0 returns all courses" do
      course = course_fixture()
      assert Courses.list_courses() == [course]
    end

    test "get_course!/1 returns the course with given id" do
      course = course_fixture()
      assert Courses.get_course!(course.id) == course
    end

    test "create_course/1 with valid data creates a course" do
      assert {:ok, %Course{} = course} = Courses.create_course(@valid_attrs)
      assert course.date == ~D[2010-04-17]
      assert course.max_participants == 42
      assert course.max_per_club == 42
      assert course.name == "some name"
      assert course.organizer_participants == 42
      assert course.released == true
      assert course.type == "some type"
    end

    test "create_course/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Courses.create_course(@invalid_attrs)
    end

    test "update_course/2 with valid data updates the course" do
      course = course_fixture()
      assert {:ok, %Course{} = course} = Courses.update_course(course, @update_attrs)
      assert course.date == ~D[2011-05-18]
      assert course.max_participants == 43
      assert course.max_per_club == 43
      assert course.name == "some updated name"
      assert course.organizer_participants == 43
      assert course.released == false
      assert course.type == "some updated type"
    end

    test "update_course/2 with invalid data returns error changeset" do
      course = course_fixture()
      assert {:error, %Ecto.Changeset{}} = Courses.update_course(course, @invalid_attrs)
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

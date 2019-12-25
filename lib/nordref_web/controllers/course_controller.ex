defmodule NordrefWeb.CourseController do
  use NordrefWeb, :controller

  alias Nordref.Courses
  alias Nordref.Registrations
  alias Nordref.Courses.Course

  def index(conn, _params) do
    courses = Courses.list_courses()
    render(conn, "index.html", courses: courses)
  end

  def new(conn, _params) do
    changeset = Courses.change_course(%Course{})
    render(conn, "new.html", changeset: changeset, types: Course.types())
  end

  def create(conn, %{"course" => course_params}) do
    case Courses.create_course(course_params) do
      {:ok, course} ->
        conn
        |> put_flash(:info, "Course created successfully.")
        |> redirect(to: Routes.course_path(conn, :show, course))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, types: Course.types())
    end
  end

  def show(conn, %{"id" => id}) do
    course = Courses.get_course!(id)
    registrations = Registrations.registrations_for_course(course)
    render(conn, "show.html", course: course, registrations: registrations)
  end

  def edit(conn, %{"id" => id}) do
    course = Courses.get_course!(id)
    changeset = Courses.change_course(course)
    render(conn, "edit.html", course: course, changeset: changeset, types: Course.types())
  end

  def update(conn, %{"id" => id, "course" => course_params}) do
    course = Courses.get_course!(id)

    case Courses.update_course(course, course_params) do
      {:ok, course} ->
        conn
        |> put_flash(:info, "Course updated successfully.")
        |> redirect(to: Routes.course_path(conn, :show, course))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", course: course, changeset: changeset, types: Course.types())
    end
  end

  def release(conn, %{"id" => id}) do
    course = Courses.get_course!(id)

    case Courses.release(course) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Course #{course.name} successfully released.")
        |> redirect(to: Routes.course_path(conn, :index))

      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Could not release course, please try again!")
        |> redirect(to: Routes.course_path(conn, :index))
    end
  end

  def delete(conn, %{"id" => id}) do
    course = Courses.get_course!(id)
    {:ok, _course} = Courses.delete_course(course)

    conn
    |> put_flash(:info, "Course deleted successfully.")
    |> redirect(to: Routes.course_path(conn, :index))
  end
end

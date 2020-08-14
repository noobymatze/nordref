defmodule NordrefWeb.CourseController do
  use NordrefWeb, :controller

  alias Nordref.Courses
  alias Nordref.Registrations
  alias Nordref.Courses.Course
  alias Nordref.Seasons
  alias Nordref.Clubs

  def index(conn, _params) do
    courses = Courses.list_courses()
    render(conn, "index.html", courses: courses)
  end

  def new(conn, _params) do
    changeset = Courses.change_course(%Course{})

    render(conn, "new.html",
      changeset: changeset,
      types: Course.types(),
      seasons: seasons_options(),
      clubs: organizer_options()
    )
  end

  def create(conn, %{"course" => course_params}) do
    case Courses.create_course(course_params) do
      {:ok, course} ->
        conn
        |> put_flash(:info, "Course created successfully.")
        |> redirect(to: Routes.course_path(conn, :show, course))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html",
          changeset: changeset,
          types: Course.types(),
          seasons: seasons_options(),
          clubs: organizer_options()
        )
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

    render(conn, "edit.html",
      course: course,
      changeset: changeset,
      types: Course.types(),
      seasons: seasons_options(),
      clubs: organizer_options()
    )
  end

  def update(conn, %{"id" => id, "course" => course_params}) do
    course = Courses.get_course!(id)

    case Courses.update_course(course, course_params) do
      {:ok, course} ->
        conn
        |> put_flash(:info, "Course updated successfully.")
        |> redirect(to: Routes.course_path(conn, :show, course))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html",
          course: course,
          changeset: changeset,
          types: Course.types(),
          seasons: seasons_options(),
          clubs: organizer_options()
        )
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

  def registration(conn, _params) do
    courses = fetch_courses()

    conn
    |> render("register.html", courses: courses)
  end

  def register_g(conn, %{"course_id" => course_id} = params) do
    user = conn.assigns[:current_user]
    course = Courses.get_course!(course_id)
    corresponding_course_id = params["corresponding_course_id"]

    if corresponding_course_id == nil do
      register_single(conn, course)
    else
      corresponding_course = Courses.get_course!(corresponding_course_id)

      case Registrations.register(user, course, corresponding_course) do
        {{:ok, _}, {:ok, _}} ->
          conn
          |> put_flash(:info, "Du wurdest erfolgreich für beide Kurse angemeldet!")
          |> redirect(to: Routes.course_path(conn, :registration))

        {{:ok, _}, {:error, _}} ->
          conn
          |> put_flash(:info, "Du wurdest erfolgreich für einen der beiden Kurse angemeldet!")
          |> redirect(to: Routes.course_path(conn, :registration))

        {{:error, _}, {:ok, _}} ->
          conn
          |> put_flash(:info, "Du wurdest erfolgreich für einen der beiden Kurse angemeldet!")
          |> redirect(to: Routes.course_path(conn, :registration))

        {{:error, _}, {:error, _}} ->
          conn
          |> put_flash(:error, "Du konntest für keinen der beiden Kurse angemeldet werden.")
          |> redirect(to: Routes.course_path(conn, :registration))
      end
    end
  end

  def register(conn, %{"id" => id}) do
    course = Courses.get_course!(id)

    corresponding_course =
      if Courses.g?(course) do
        Courses.get_corresponding_g_course(course)
      else
        nil
      end

    if corresponding_course != nil do
      user = conn.assigns[:current_user]
      if Registrations.registered_for_course?(corresponding_course, user) do
        register_single(conn, course)
      else
        conn
        |> render("register_g.html", course: course, corresponding_course: corresponding_course)
      end
    else
      case corresponding_course do
        nil ->
          register_single(conn, course)

        _ ->
          conn
          |> render("register_g.html", course: course, corresponding_course: corresponding_course)
      end
    end
  end

  defp register_single(conn, course) do
    user = conn.assigns[:current_user]

    case Registrations.register(user, course) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Du wurdest erfolgreich für den Kurs #{course.name} angemeldet!")
        |> redirect(to: Routes.course_path(conn, :registration))

      {:error, :not_allowed} ->
        conn
        |> put_flash(:error, "Du bist schon für einen Kurs angemeldet, bitte melde dich dort ab.")
        |> redirect(to: Routes.course_path(conn, :registration))

      {:error, :not_available} ->
        conn
        |> put_flash(
          :error,
          "Es tut uns leid, aber es gibt keine freien Plätze mehr für den Kurs #{course.name}."
        )
        |> redirect(to: Routes.course_path(conn, :registration))
    end
  end

  defp fetch_courses do
    Courses.list_courses_view()
    |> Enum.group_by(fn c ->
      if String.starts_with?(c.type, "G") do
        "G"
      else
        c.type
      end
    end)
    |> Enum.to_list()
    |> Enum.sort_by(fn {type, _} ->
      cond do
        type == "F" ->
          0

        type == "J" ->
          1

        String.starts_with?(type, "G") ->
          2
      end
    end)
  end

  defp organizer_options do
    Clubs.list_clubs()
    |> Enum.reduce(%{}, fn ra, acc -> Map.put(acc, ra.name, ra.id) end)
  end

  defp seasons_options do
    Seasons.list_seasons()
    |> Enum.reduce(%{}, fn ra, acc -> Map.put(acc, ra.year, ra.year) end)
  end
end

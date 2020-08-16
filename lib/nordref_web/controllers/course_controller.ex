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
    season = Seasons.current_season()

    if season == nil do
      conn
      |> put_status(:not_found)
      |> put_view(NordrefWeb.ErrorView)
      |> render(:"404")
    else
      with {:ok, courses} <- Courses.list_and_organize_courses(season) do
        conn
        |> render("register.html", courses: courses)
      else
        {:error, {:locked_until, _start_registration}} ->
          conn
          |> put_flash(:error, "Die Kursanmeldung ist noch gesperrt.")
          |> render("register.html", courses: [])

        {:error, {:locked_since, _end_registration}} ->
          conn
          |> put_flash(:error, "Die Kursanmeldung ist schon beendet.")
          |> render("register.html", courses: [])
      end
    end
  end

  def register(conn, %{"id" => id}) do
    user = conn.assigns[:current_user]
    course = Courses.get_course!(id)

    case Registrations.register(user, course, :check_for_corresponding) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Du wurdest erfolgreich für den Kurs #{course.name} angemeldet!")
        |> redirect(to: Routes.course_path(conn, :registration))

      error ->
        handle_registration_error(conn, error)
    end
  end

  def register_g(conn, %{"course_id" => course_id} = params) do
    user = conn.assigns[:current_user]
    course = Courses.get_course!(course_id)
    corresponding_course_id = params["corresponding_course_id"]

    if corresponding_course_id == nil do
      case Registrations.register(user, course) do
        {:ok, _} ->
          conn
          |> put_flash(:info, "Du wurdest erfolgreich für den Kurs #{course.name} angemeldet!")
          |> redirect(to: Routes.course_path(conn, :registration))

        error ->
          handle_registration_error(conn, error)
      end
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

  defp handle_registration_error(conn, error) do
    case error do
      {:error, {:register_for?, course, corresponding_course}} ->
        conn
        |> render("register_g.html", course: course, corresponding_course: corresponding_course)

      {:error, {:not_allowed, _}} ->
        conn
        |> put_flash(:error, "Du bist schon für einen Kurs angemeldet, bitte melde dich dort ab.")
        |> redirect(to: Routes.course_path(conn, :registration))

      {:error, {:not_available, course}} ->
        conn
        |> put_flash(:error, "Es gibt keine freien Plätze mehr für den Kurs #{course.name}.")
        |> redirect(to: Routes.course_path(conn, :registration))
    end
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

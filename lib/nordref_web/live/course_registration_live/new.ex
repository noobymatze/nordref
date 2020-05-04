defmodule NordrefWeb.CourseRegistrationLive.New do
  use NordrefWeb, :live_view

  alias Nordref.Courses
  alias Nordref.Courses.CourseRegistration
  alias Nordref.Registrations
  alias Nordref.Users

  @impl true
  def mount(_params, session, socket) do
    new_socket =
      socket
      |> assign(:courses, fetch_courses())
      |> assign(:user_id, session["current_user_id"])
    {:ok, new_socket}
  end

  def handle_event("register", params, socket) do
    course = Courses.get_course!(params["course_id"])
    user = Users.get_user!(params["user_id"])
    Registrations.register(user, course)
    {:noreply, assign(socket, :selected_course, course)}
  end

  def handle_event("register_g", params, socket) do
    course = Courses.get_course!(params["course_id"])
    other_course =
      case course.type do
        "G2" ->
          course.name
          |> String.replace("G2", "G3")
          |> Courses.get_course_by_name()

        "G2" ->
          course.name
          |> String.replace("G2", "G3")
          |> Courses.get_course_by_name()
      end

    {:noreply, assign(socket, :selected_course, course)}
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
    |> Enum.sort_by(fn {type, c} ->
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

  def register_event(course) do
    if String.starts_with?(course.type, "G") do
      "register_g"
    else
      "register"
    end
  end

  def selected_attr(nil, _), do: ""
  def selected_attr(course, id) do
    if course.id == id do
      "selected='selected'"
    else
      ""
    end
  end
end

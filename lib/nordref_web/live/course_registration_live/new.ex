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

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("register", params, socket) do
    course = Courses.get_course!(params["course_id"])
    user = Users.get_user!(params["user_id"])
    Registrations.register(user, course)
    {:noreply, assign(socket, :course, course)}
  end

  def handle_event("register_g", params, socket) do
    course = Courses.get_course!(params["course_id"])
    other_course = Courses.get_corresponding_g_course(course)
    user = Users.get_user!(params["user_id"])

    if other_course == nil do
      Registrations.register(user, course)
      {:noreply, assign(socket, :course, course)}
    else
      {:noreply,
       socket
       |> assign(:live_action, :check)
       |> assign(:course, course)
       |> assign(:other_course, other_course)}
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

  def g?(course) do
    Courses.g?(course)
  end

  def register_event(course) do
    if Courses.g?(course) do
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

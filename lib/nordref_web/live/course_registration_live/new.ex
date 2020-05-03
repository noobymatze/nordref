defmodule NordrefWeb.CourseRegistrationLive.New do
  use NordrefWeb, :live_view

  alias Nordref.Courses
  alias Nordref.Courses.CourseRegistration

  @impl true
  def mount(_params, _session, socket) do
    new_socket =
      socket
      |> assign(:courses, fetch_courses())
      |> assign(:selected_course, nil)
    {:ok, new_socket}
  end

  def handle_event("register", params, socket) do
    course = Courses.get_course!(params["course-id"])
    {:noreply, assign(socket, :selected_course, course)}
  end

  defp fetch_courses do
    Courses.list_courses_view()
    |> Enum.group_by(fn c -> {c.date.year, c.date.month} end)
    |> Enum.to_list()
    |> Enum.sort_by(fn {a, _} -> a end)
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

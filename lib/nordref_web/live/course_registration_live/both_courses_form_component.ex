defmodule NordrefWeb.CourseRegistrationLive.BothCoursesFormComponent do
  use NordrefWeb, :live_component

  alias Nordref.Courses
  alias Nordref.Registration.Register

  @impl true
  def handle_event("both", params, socket) do
    Courses.get
    {:noreply, socket}
  end

  def handle_event("no", params, socket) do
    {:noreply, socket}
  end
end

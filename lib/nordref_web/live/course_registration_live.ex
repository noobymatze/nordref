defmodule NordrefWeb.Live.CourseRegistrationLive do
  use Phoenix.LiveView
  require Logger
  alias Nordref.Courses

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <form phx-change="update_course">
      <div class="test">Hello World</div>
      <select name="course_id">
          <option value="1">Test</option>
          <option value="2">Lol</option>
      </select>
    </form>
    """
  end

  def handle_event("update_course", params, socket) do
    IO.puts(params)
    {:noreply, socket}
  end
end
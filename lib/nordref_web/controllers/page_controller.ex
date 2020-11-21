defmodule NordrefWeb.PageController do
  use NordrefWeb, :controller

  alias Nordref.MyCourses

  def index(conn, _params) do
    current_user = conn.assigns[:current_user]
    courses = MyCourses.list_my_courses(current_user)
    render(conn, "index.html", courses: courses)
  end

end
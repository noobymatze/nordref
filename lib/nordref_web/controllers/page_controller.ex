defmodule NordrefWeb.PageController do
  use NordrefWeb, :controller

  alias Nordref.Clubs
  alias Nordref.MyCourses

  def index(conn, _params) do
    current_user = conn.assigns[:current_user]
    courses = MyCourses.list_my_courses(current_user)
    render(conn, "index.html", courses: courses)
  end

  def club_members(conn, params) do
    current_user = conn.assigns[:current_user]
    club_members = Clubs.club_members(current_user.club_id)
    render(conn, "club_members.html", club_members: club_members)
  end
end

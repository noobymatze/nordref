defmodule NordrefWeb.CourseView do
  use NordrefWeb, :view

  alias Nordref.Courses

  def g?(course) do
    Courses.g?(course)
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

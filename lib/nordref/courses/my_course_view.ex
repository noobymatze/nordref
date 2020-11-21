defmodule Nordref.Courses.MyCoursesView do
  use Ecto.Schema

  schema "my_courses_view" do
    field :date, :naive_datetime
    field :name, :string
    field :season, :id
    field :type, :string
    field :user_id, :id
    field :organizer_id, :id
    field :club_name, :string
    field :club_short_name, :string
    field :club_association_id, :id
  end
end

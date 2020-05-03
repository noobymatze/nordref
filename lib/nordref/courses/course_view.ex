defmodule Nordref.Courses.CourseView do
  use Ecto.Schema

  schema "courses_view" do
    field :date, :naive_datetime
    field :max_participants, :integer
    field :max_per_club, :integer
    field :name, :string
    field :max_organizer_participants, :integer
    field :released, :boolean, default: false
    field :type, :string
    field :organizer_id, :id
    field :season, :id
    field :club_name, :string
    field :club_short_name, :string
    field :club_association_id, :id

    timestamps()
  end
end

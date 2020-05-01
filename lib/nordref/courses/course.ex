defmodule Nordref.Courses.Course do
  use Ecto.Schema
  import Ecto.Changeset

  schema "courses" do
    field :date, :naive_datetime
    field :max_participants, :integer
    field :max_per_club, :integer
    field :name, :string
    field :max_organizer_participants, :integer
    field :released, :boolean, default: false
    field :type, :string
    field :organizer_id, :id
    field :season, :id

    timestamps()
  end

  @doc false
  def types do
    ["F", "J", "G2", "G3"]
  end

  @doc false
  def changeset(course, attrs) do
    course
    |> cast(attrs, [
      :name,
      :max_participants,
      :max_per_club,
      :max_organizer_participants,
      :type,
      :date,
      :released,
      :organizer_id,
      :season
    ])
    |> validate_required([
      :name,
      :max_participants,
      :max_per_club,
      :max_organizer_participants,
      :type,
      :date,
      :released,
      :organizer_id,
      :season
    ])
    |> validate_inclusion(:type, types())
  end
end

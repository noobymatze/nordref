defmodule Nordref.Courses.Course do
  use Ecto.Schema
  import Ecto.Changeset

  schema "courses" do
    field :date, :date
    field :max_participants, :integer
    field :max_per_club, :integer
    field :name, :string
    field :organizer_participants, :integer
    field :released, :boolean, default: false
    field :type, :string
    field :organizer, :id
    field :season, :integer

    timestamps(inserted_at: :created_at)
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
      :organizer_participants,
      :type,
      :date,
      :released,
      :organizer
    ])
    |> validate_required([
      :name,
      :max_participants,
      :max_per_club,
      :organizer_participants,
      :type,
      :date,
      :released,
      :organizer
    ])
    |> validate_inclusion(:type, types())
  end
end

defmodule Nordref.Courses.CourseRegistration do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :course_id, :id
    field :g_course_id, :id
  end

  @doc false
  def changeset(registration, attrs \\ %{}) do
    registration
    |> cast(attrs, [:course_id, :g_course_id])
    |> validate_required([:course_id])
  end
end

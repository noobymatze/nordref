defmodule Nordref.Registrations.Registration do
  use Ecto.Schema
  import Ecto.Changeset

  schema "registrations" do
    field :course_id, :id
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(registration, attrs) do
    registration
    |> cast(attrs, [:course_id, :user_id])
    |> validate_required([:course_id, :user_id])
  end
end

defmodule Nordref.Registrations.Registration do
  use Ecto.Schema
  import Ecto.Changeset

  schema "registrations" do
    field :birthday, :date
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :license_number, :string
    field :club_id, :id
    field :course_id, :id
    field :user_id, :id

    timestamps(inserted_at: :created_at)
  end

  @doc false
  def changeset(registration, attrs) do
    registration
    |> cast(attrs, [:email, :first_name, :last_name, :birthday, :license_number])
    |> validate_required([:email, :first_name, :last_name, :birthday, :license_number])
  end
end

defmodule Nordref.Registrations.RegistrationView do
  use Ecto.Schema

  @primary_key false
  schema "registrations_view" do
    field :user_id, :integer
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :club_id, :integer
    field :club_name, :string
    field :club_short_name, :string
    field :course_id, :integer
    field :created_at, :naive_datetime
    field :updated_at, :naive_datetime
  end
end

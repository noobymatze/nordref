defmodule Nordref.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :birthday, :date
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :mobile, :string
    field :password, :string
    field :phone, :string
    field :role, :string
    field :username, :string
    field :club_id, :id

    timestamps(inserted_at: :created_at)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :email, :username, :password, :birthday, :mobile, :phone, :role])
    |> validate_required([:first_name, :last_name, :email, :username, :birthday, :role])
  end

  @doc false
  def roles do
    ["SUPER_ADMIN","ADMIN","CLUB_ADMIN","INSTRUCTOR","USER"]
  end
end

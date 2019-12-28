defmodule Nordref.Users.Login do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :username, :string
    field :password, :string
  end

  @doc false
  def changeset(login, attrs \\ %{}) do
    login
    |> cast(attrs, [:username, :password])
    |> validate_required([:username, :password])
  end
end

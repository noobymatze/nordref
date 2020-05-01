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

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [
      :first_name,
      :last_name,
      :email,
      :username,
      :password,
      :birthday,
      :mobile,
      :phone,
      :role,
      :club_id
    ])
    |> validate_required([:first_name, :last_name, :email, :username, :birthday, :role, :club_id])
    |> validate_inclusion(:role, roles())
  end

  @doc """
  Return all existing roles for a user.

  ## Examples

      iex> roles
      ["SUPER_ADMIN", "ADMIN", "CLUB_ADMIN", "INSTRUCTOR", "USER"]

  """
  def roles do
    ["SUPER_ADMIN", "ADMIN", "CLUB_ADMIN", "INSTRUCTOR", "USER"]
  end

  @doc """
  Check, if the given user is a `SUPER_ADMIN`.

  ## Examples

      iex> super_admin?(%{role: "SUPER_ADMIN"})
      true

      iex> super_admin?(%{role: nil})
      false
  """
  def super_admin?(user) do
    user.role == "SUPER_ADMIN"
  end

  @doc """
  Check, if the given user is an `ADMIN`.

  ## Examples

      iex> admin?(%{role: "ADMIN"})
      true

      iex> admin?(%{role: nil})
      false
  """
  def admin?(user) do
    user.role == "ADMIN"
  end

  @doc """
  Check, if the given user is a `CLUB_ADMIN`.

  ## Examples

      iex> club_admin?(%{role: "CLUB_ADMIN"})
      true

      iex> club_admin?(%{role: nil})
      false
  """
  def club_admin?(user) do
    user.role == "CLUB_ADMIN"
  end

  @doc """
  Check, if the given user is an `INSTRUCTOR`.

  ## Examples

      iex> instructor?(%{role: "INSTRUCTOR"})
      true

      iex> instructor?(%{role: nil})
      false
  """
  def instructor?(user) do
    user.role == "INSTRUCTOR"
  end

  @doc """
  Check, if the given user is a `USER`.

  ## Examples

      iex> user?(%{role: "USER"})
      true

      iex> user?(%{role: nil})
      false
  """
  def user?(user) do
    user.role == "USER"
  end
end

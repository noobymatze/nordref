defmodule Nordref.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  import Ecto.Changeset
  alias Nordref.Repo

  alias Nordref.Users.User
  alias Nordref.Users.Security
  alias Nordref.Users.Login

  alias Nordref.Clubs.Club

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  def list_admins_and_instructors() do
    query =
      from usr in User,
        order_by: usr.last_name,
        where: usr.role == "ADMIN" or usr.role == "INSTRUCTOR",
        select: usr

    Repo.all(query)
  end

  def list_admins_and_instructors(id) do
    query =
      from usr in User,
        join: c in Club,
        on: c.id == usr.club_id,
        order_by: usr.last_name,
        where: (usr.role == "ADMIN" or usr.role == "INSTRUCTOR") and c.association_id == ^id,
        select: usr

    Repo.all(query)
  end

  # def list_users_by_roles([]) do
  #  list_users()
  # end

  # def list_users_by_roles(roles) do
  #  query =
  #    from usr in User,
  #      order_by: usr.last_name,
  #      where: Enum.reduce(fn role, role_acc -> role_acc or role == usr.role end, roles),
  #      select: usr

  #  Repo.all(query)
  # end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking login changes.

  ## Examples

      iex> change_login(login)
      %Ecto.Changeset{source: %Login{}}
  """
  def change_login(%Login{} = login) do
    Login.changeset(login, %{})
  end

  @doc """
  Returns a User by their username or nil, if none
  could be found.

  ## Examples

      iex> get_by_username("test")
      %Ecto.User{}

      iex> get_by_username("not_existing")
      nil
  """
  def get_by_username(username) do
    query =
      from u in User,
        where: u.username == ^username

    Repo.one(query)
  end

  @doc """
  Authenticate a user by their username and password.

  ## Examples

      iex> authenticate(%Login{username: "test", password: "secret"})
      {:ok, %Ecto.User{}}

      iex> authenticate(%Login{username: "don_t_exist", password: "secret"})
      {:error, %Ecto.Changeset{}}

      iex> authenticate(%Login{username: "test", password: "wrong"})
      {:error, %Ecto.Changeset{}}

  """
  def authenticate(login_params) do
    changeset = Login.changeset(%Login{}, login_params)

    with {:ok, login} <- apply_action(changeset, :login),
         %User{} = user <- get_by_username(login.username),
         true <- Security.verify(login.password, user.password) do
      {:ok, user}
    else
      {:error, %Ecto.Changeset{} = changes} ->
        {:error, changes}

      false ->
        {:error, {:invalid_username_or_password, changeset}}

      _ ->
        {:error, {:invalid_username_or_password, changeset}}
    end
  end
end

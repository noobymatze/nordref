defmodule Nordref.Courses do
  @moduledoc """
  The Courses context.
  """

  import Ecto.Query, warn: false
  alias Nordref.Repo

  alias Nordref.Courses.Course
  alias Nordref.Registrations
  alias Nordref.Registrations.Registration
  alias Nordref.Registrations.RegistrationView
  alias Nordref.Users.User

  @doc """
  Register a user for a course.

  **Important note:** This only works, if a user has not
  been registered yet for the season or
  This will only work, if a user has not been registered yet
  for the season of the course.
  """
  def register(%User{} = user, %Course{} = course) do
    course
    |> available_for?(user)

    registration = %{
      :user_id => user.id,
      :course_id => course.id
    }

    Registrations.create_registration(registration)
  end

  defp available_for?(%Course{} = course, %User{} = user) do
    %{true => from_organizer, false => others} =
      course
      |> get_registrations
      |> Enum.group_by(fn r -> r.club_id == course.organizer end)

    from_organizer_and_allowed? =
      user.club_id == course.organizer &&
        length(from_organizer) < course.organizer_participants

    max =
      course.max_participants -
        if course.released do
          length(from_organizer) + length(others)
        else
          course.organizer_participants
        end

    from_others_and_allowed? =
      user.club_id != course.organizer &&
        length(others) < max

    from_others_and_allowed? || from_organizer_and_allowed?
  end

  @doc """
  Returns the list of registrations for the given course.

  Returns an empty list, if the course does not exist.

  ## Examples

      iex> get_registrations(course)
      {:ok, [%RegistrationView{}]}

  """
  def get_registrations(%Course{} = course) do
    query =
      from r in RegistrationView,
        where: r.course_id == ^course.id,
        select: r

    Repo.all(query)
  end

  @doc """
  Returns the list of courses.

  ## Examples

      iex> list_courses()
      [%Course{}, ...]

  """
  def list_courses do
    Repo.all(Course)
  end

  @doc """
  Gets a single course.

  Raises `Ecto.NoResultsError` if the Course does not exist.

  ## Examples

      iex> get_course!(123)
      %Course{}

      iex> get_course!(456)
      ** (Ecto.NoResultsError)

  """
  def get_course!(id), do: Repo.get!(Course, id)

  @doc """
  Creates a course.

  ## Examples

      iex> create_course(%{field: value})
      {:ok, %Course{}}

      iex> create_course(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_course(attrs \\ %{}) do
    %Course{}
    |> Course.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a course.

  ## Examples

      iex> update_course(course, %{field: new_value})
      {:ok, %Course{}}

      iex> update_course(course, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_course(%Course{} = course, attrs) do
    course
    |> Course.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Course.

  ## Examples

      iex> delete_course(course)
      {:ok, %Course{}}

      iex> delete_course(course)
      {:error, %Ecto.Changeset{}}

  """
  def delete_course(%Course{} = course) do
    Repo.delete(course)
  end

  @doc """
  Release
  """
  def release(%Course{} = course) do
    update_course(course, %{:released => true})
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking course changes.

  ## Examples

      iex> change_course(course)
      %Ecto.Changeset{source: %Course{}}

  """
  def change_course(%Course{} = course) do
    Course.changeset(course, %{})
  end
end

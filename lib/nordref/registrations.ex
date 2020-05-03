defmodule Nordref.Registrations do
  @moduledoc """
  The Registrations context.
  """

  import Ecto.Query, warn: false
  alias Nordref.Repo

  alias Nordref.Registrations.Registration
  alias Nordref.Registrations.RegistrationView
  alias Nordref.Users.User
  alias Nordref.Courses.Course
  alias Nordref.Registrations.Register

  def list_registrations do
    Repo.all(RegistrationView)
  end

  def get_registration!(id), do: Repo.get!(Registration, id)

  @doc """
  Register the given user for the given course.

  The user is allowed to participate in a course iff:

    1. There is a seat available.
    2. They have not been signed up for a course
       this season, except it is a G-course and the
       given course is the corresponding G-course.

  ## Examples

      iex> register(user, course)
      {:ok, %Registration{}}

      iex> register(user, course)
      {:error, :not_allowed}

      iex> register(user, course)
      {:error, :not_available}
  """
  def register(%User{} = user, %Course{} = course) do
    cond do
      not Register.seat_available?(user, course, registrations_for_course(course)) ->
        {:error, :not_available}

      not Register.allowed?(user, course) ->
        {:error, :not_allowed}

      true ->
        create_registration(%{
          user_id: user.id,
          course_id: course.id
        })
    end
  end

  @doc """
  Returns the list of registrations for the given course.

  ## Examples

      iex> get_registrations(course)
      [%RegistrationView{}, ...]

  """
  def registrations_for_course(%Course{} = course) do
    query =
      from r in RegistrationView,
        where: r.course_id == ^course.id

    Repo.all(query)
  end

  @doc """
  Creates a registration.

  ## Examples

      iex> create_registration(%{field: value})
      {:ok, %Registration{}}

      iex> create_registration(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_registration(attrs \\ %{}) do
    registration =
      %Registration{}
      |> Registration.changeset(attrs)

    registration |> Repo.insert()
  end

  @doc """
  Deletes a Registration.

  ## Examples

      iex> delete_registration(registration)
      {:ok, %Registration{}}

      iex> delete_registration(registration)
      {:error, %Ecto.Changeset{}}

  """
  def delete_registration(%Registration{} = registration) do
    Repo.delete(registration)
  end

  @doc """
  Export all registrations for the given season as CSV.

  ## Examples

      iex> export_for_season(2019, :csv)
      "id,first_name,last_name,birthday,club_name,course_name" <> ...


  """
  def export_for_season(season, :csv) do
    query =
      from r in RegistrationView,
        where: r.season == ^season

    query
    |> Repo.all()
    |> Enum.map(&RegistrationView.to_public_map/1)
    |> CSV.encode(headers: true, separator: ?,)
    |> Enum.into("")
  end

  defmodule Register do
    @moduledoc false

    @doc """
    Check, if a seat is available for the user for the given course.
    """
    def seat_available?(%User{} = user, %Course{} = course, course_registrations) do
      %{true => from_organizer, false => others} =
        course_registrations
        |> Enum.group_by(fn r -> r.club_id == course.organizer_id end)

      from_organizer_and_allowed? =
        user.club_id == course.organizer_id &&
          length(from_organizer) < course.max_organizer_participants

      max =
        course.max_participants -
          if course.released do
            length(from_organizer) + length(others)
          else
            course.max_organizer_participants
          end

      from_others_and_allowed? =
        user.club_id != course.organizer_id &&
          length(others) < max

      from_others_and_allowed? or from_organizer_and_allowed?
    end

    @doc """
    Check, if the user is allowed to participate in the
    given course.

    There are two rules, to be aware of:

      1. The user has not been registered yet.
      2. The user has been registered for a course
         AND the course is a G course AND the given
         course is the corresponding G course.

    ## Examples

        iex> allowed?(user, 2019)
        true

        iex> allowed?(user, 2019)
        false
    """
    def allowed?(%User{} = user, %Course{} = course) do
      query =
        from r in Registration,
          join: c in Course,
          on: c.id == r.course_id,
          where: r.user_id == ^user.id and c.season == ^course.season,
          select: %{id: r.id, type: c.type}

      registrations = Repo.all(query)
      not registered?(registrations) or (one?(registrations, &g?/1) and g?(course))
    end

    defp registered?(registrations) do
      not Enum.empty?(registrations)
    end

    defp one?(list, pred) do
      Enum.count(list, pred) == 1
    end

    defp g?(registration) do
      registration[:type] == "G2" or registration[:type] == "G3"
    end
  end
end

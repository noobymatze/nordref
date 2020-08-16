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
  alias Nordref.Courses
  alias Nordref.Registrations.Register

  def list_registrations do
    Repo.all(RegistrationView)
  end

  def get_registration!(id), do: Repo.get!(Registration, id)

  @doc """
  Register the given user for the course or if a corresponding course exists,
  ask for clarification, whether both should be registered.

  ## Examples

      iex> register(user, course)
      {:ok, %Registration{}}

      iex> register(user, course)
      {:error, :not_allowed}

      iex> register(user, course)
      {:error, :not_available}

      iex> register(user, course)
      {:error, {:also_register_for?, corresponding_course}}
  """
  def register(%User{} = user, %Course{} = course, :check_for_corresponding) do
    corresponding_course = Courses.get_corresponding_g_course(course)

    if corresponding_course != nil and not registered?(course, user) do
      {:error, {:register_for?, course, corresponding_course}}
    else
      register(user, course)
    end
  end

  @doc """
  Register the given user for two g courses.

  The two courses will be registered independently, meaning
  in two separate transactions.

  The user is allowed to participate in a course iff:

    1. There is a seat available.
    2. They have not been signed up for a course
       this season, except it is a G-course and the
       given course is the corresponding G-course.

  ## Examples

      iex> register(user, course1, course2)
      {{:ok, %Registration{}}, {:ok, %Registration{}}}

      iex> register(user, course)
      {{:error, :not_allowed}, {:error, :not_allowed}}

      iex> register(user, course)
      {:error, :not_available}
  """
  def register(%User{} = user, %Course{} = course1, %Course{} = course2) do
    case {Courses.g?(course1), Courses.g?(course2)} do
      {true, true} ->
        [course1, course2]
        |> Enum.map(fn course -> register(user, course) end)
        |> List.to_tuple()

      _ ->
        {:error, :not_g_course}
    end
  end

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
    Repo.transaction(fn ->
      # Locking the course happens, so no other transaction can concurrently
      # add another referee to the course. If we didn't do that, we may
      # exceed the number of allowed participants per course.
      #
      # The lock will automatically be freed after the end of this transaction.
      locked_course = Courses.get_and_lock_course(course.id)

      cond do
        not Register.seat_available?(user, course, registrations_for_course(course)) ->
          Repo.rollback({:not_available, course})

        not Register.allowed?(user, course) ->
          Repo.rollback({:not_allowed, course})

        true ->
          attrs = %{
            user_id: user.id,
            course_id: course.id
          }

          with {:ok, registration} <- create_registration(attrs) do
            registration
          end
      end
    end)
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

    Repo.insert(registration)
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
  Check, if the user has been registered for the given course.
  """
  defp registered?(course, user) do
    query =
      from r in Registration,
        join: c in Course,
        on: c.id == r.course_id,
        where: r.user_id == ^user.id and c.season == ^course.season,
        select: count(r.id)

    Repo.one(query) > 0
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
      {from_organizer, others} = course_registrations |> group_by_organizer(course)

      from_organizer_and_allowed? =
        user.club_id == course.organizer_id &&
          length(from_organizer) <= course.max_organizer_participants &&
          course.max_organizer_participants > 0

      max =
        course.max_participants -
          if course.released do
            length(from_organizer) + length(others)
          else
            course.max_organizer_participants
          end

      from_others_and_allowed? =
        user.club_id != course.organizer_id &&
          length(others) <= max &&
          max > 0

      from_others_and_allowed? or from_organizer_and_allowed?
    end

    defp group_by_organizer(course_registrations, %Course{} = course) do
      result =
        course_registrations
        |> Enum.group_by(fn r -> r.club_id == course.organizer_id end)

      {Map.get(result, true, []), Map.get(result, false, [])}
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
      not registered?(registrations) or (one?(registrations, &g?/1) and Courses.g?(course))
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

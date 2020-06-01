defmodule Nordref.Courses do
  @moduledoc """
  The Courses context.
  """

  import Ecto.Query, warn: false
  alias Nordref.Repo

  alias Nordref.Courses.Course
  alias Nordref.Courses.CourseView

  @doc """
  Release the given course.

  This means, all previously reserved seats for the organizer
  of the course will be available for everyone else.

  ## Examples

      iex> release(course)
      {:ok, %Course{}}
  """
  def release(%Course{} = course) do
    update_course(course, %{:released => true})
  end

  @doc """
  Returns the list of courses.

  ## Examples

      iex> list_courses()
      [%Course{}, ...]

  """
  def list_courses do
    query =
      from c in Course,
        order_by: c.name,
        select: c

    Repo.all(query)
  end

  @doc """
  Returns the list of courses views.

  ## Examples

      iex> list_courses_view()
      [%CourseView{}, ...]

  """
  def list_courses_view do
    query =
      from c in CourseView,
        order_by: c.name,
        select: c

    Repo.all(query)
  end

  @doc """
  Check, if the given course is a G course.

  ## Examples

      iex> g?(%Course{type: "G2"})
      true

      iex> g?(%Course{type: "J"})
      false
  """
  def g?(course) do
    String.starts_with?(course.type, "G")
  end

  @doc """
  Gets the corresponding G course of the given course or nil
  if none could be found.

  ## Examples

      iex> get_course_by_name("test")
      %Course{}

      iex> get_course("bla")
      nil

  """
  def get_corresponding_g_course(%Course{} = course) do
    case course.type do
      "G2" ->
        course.name
        |> String.replace("G2", "G3")
        |> get_course_by_name()

      "G3" ->
        course.name
        |> String.replace("G3", "G2")
        |> get_course_by_name()

      _ ->
        nil
    end
  end

  @doc """
  Gets a single course by name.

  ## Examples

      iex> get_course_by_name("test")
      %Course{}

      iex> get_course("bla")
      nil

  """
  def get_course_by_name(name) do
    query =
      from c in Course,
        where: c.name == ^name,
        select: c

    Repo.one(query)
  end

  @doc """
  Gets a single course and locks it for this transaction.

  ## Examples

      iex> get_course(123)
      %Course{}

      iex> get_course(456)
      {:error, :not_found}

  """
  def get_and_lock_course(id) do
    query =
      from c in Course,
        where: c.id == ^id,
        lock: "FOR UPDATE"

    Repo.one(query)
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
  Returns an `%Ecto.Changeset{}` for tracking course changes.

  ## Examples

      iex> change_course(course)
      %Ecto.Changeset{source: %Course{}}

  """
  def change_course(%Course{} = course) do
    Course.changeset(course, %{})
  end
end

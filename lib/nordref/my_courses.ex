defmodule Nordref.MyCourses do
  @moduledoc """
  The context for MyCourses
  """

  import Ecto.Query, warn: false
  alias Nordref.Repo

  alias Nordref.Courses.Course
  alias Nordref.Users.User
  alias Nordref.Courses.MyCoursesView

  @doc """
  List all registrations of the given user.

  ## Examples

    iex> list_my_courses(user)
    []
  """
  def list_my_courses(%User{} = user) do
    query =
      from c in MyCoursesView,
         where: c.user_id == ^user.id,
         order_by: c.season,
         select: c

    Repo.all(query)
  end

end
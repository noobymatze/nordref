defmodule Nordref.Registrations.RegistrationView do
  use Ecto.Schema

  @primary_key false
  schema "registrations_view" do
    field :id, :id
    field :user_id, :integer
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :birthday, :date
    field :club_id, :integer
    field :club_name, :string
    field :club_short_name, :string
    field :course_id, :integer
    field :course_name, :string
    field :season, :integer
    field :current_license_number, :integer
    field :previous_license_number, :integer
    field :created_at, :naive_datetime
    field :updated_at, :naive_datetime
  end

  @doc """
  Define the publicly available data for the given `%RegistrationView{}`.

  ## Examples

      iex> to_public_map(%RegistrationView{})
      %{id: nil, email: nil, first_name: nil, last_name: nil, club: nil, birthday: nil, course: nil, license_number: nil}
  """
  def to_public_map(r) do
    %{
      id: r.id,
      email: r.email,
      first_name: r.first_name,
      last_name: r.last_name,
      club: r.club_name,
      birthday: r.birthday,
      course: r.course_name,
      license_number: r.current_license_number || r.previous_license_number
    }
  end
end

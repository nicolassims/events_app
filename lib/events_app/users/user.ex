defmodule EventsApp.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :name, :string
    field :password, :string
    field :photo_hash, :string

    timestamps()

    has_many :events, EventsApp.Events.Event
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :photo_hash, :email, :password])
    |> validate_required([:name, :photo_hash, :email, :password])
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/^[A-z0-9._%+-]+@[A-z0-9.-]+\.[A-z]{2,}$/)
  end
end

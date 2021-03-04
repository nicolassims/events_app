defmodule EventsApp.Events.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field :name, :string
    field :date, :naive_datetime
    field :body, :string

    timestamps()

    belongs_to :user, EventsApp.Users.User
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:body, :name, :date, :user_id])
    |> validate_required([:body, :name, :date, :user_id])
  end
end

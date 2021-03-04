defmodule EventsApp.Events.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field :body, :string

    timestamps()

    belongs_to :user, EventsApp.Users.User
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:body])
    |> validate_required([:body])
  end
end

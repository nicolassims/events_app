defmodule EventsApp.Comments.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :body, :string
    field :response, :integer
    belongs_to :event, EventsApp.Events.Event
    belongs_to :user, EventsApp.Users.User

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:body, :response, :post_id, :user_id])
    |> validate_required([:body, :response, :post_id, :user_id])
  end
end

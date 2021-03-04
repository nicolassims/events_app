defmodule EventsApp.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :user_id, references(:users), null: false
      add :name, :text, null: false
      add :date, :naive_datetime, null: false
      add :body, :text, null: false
      add :guests, :text, null: false

      timestamps()
    end

  end
end

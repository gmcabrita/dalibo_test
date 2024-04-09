defmodule DaliboTest.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :text
      add :email, :text

      timestamps(type: :utc_datetime)
    end
  end
end

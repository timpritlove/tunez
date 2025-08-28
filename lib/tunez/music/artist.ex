defmodule Tunez.Music.Artist do
  use Ash.Resource, otp_app: :tunez, domain: Tunez.Music, data_layer: AshPostgres.DataLayer

  postgres do
    table "artists"
    repo Tunez.Repo
  end

  relationships do
    has_many :albums, Tunez.Music.Album do
      sort year_released: :desc
    end
  end

  attributes do
    uuid_primary_key :id
    attribute :name, :string do
      allow_nil? false
    end
    attribute :previous_names, {:array, :string} do
      default []
    end
    attribute :biography, :string

    create_timestamp :created_at
    update_timestamp :updated_at
  end

  actions do
    create :create do
      accept [:name, :biography]
    end

    read :read do
      primary? true
    end

    read :search do
      argument :query, :ci_string do
        constraints allow_empty?: true
        default ""
      end
      filter expr(contains(name, ^arg(:query)))
    end

    update :update do
      accept [:name, :biography]
      require_atomic? false
      change Tunez.Music.Changes.UpdatePreviousNames, where: [changing(:name)]
    end

    destroy :destroy do
    end
  end
end

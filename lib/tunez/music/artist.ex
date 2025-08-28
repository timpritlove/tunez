defmodule Tunez.Music.Artist do
  use Ash.Resource, otp_app: :tunez, domain: Tunez.Music, data_layer: AshPostgres.DataLayer

  postgres do
    table "artists"
    repo Tunez.Repo
    custom_indexes do
      index "name gin_trgm_ops", name: "artists_name_gin_index", using: "GIN"
    end
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
      public? true
    end
    attribute :previous_names, {:array, :string} do
      default []
    end
    attribute :biography, :string

    create_timestamp :inserted_at, public?: true
    update_timestamp :updated_at, public?: true
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
      pagination offset?: true, default_limit: 12
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

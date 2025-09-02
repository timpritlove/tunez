defmodule Tunez.Music.Track do
  use Ash.Resource,
    otp_app: :tunez,
    domain: Tunez.Music,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer]

  postgres do
    table "tracks"
    repo Tunez.Repo

    references do
      reference :album, index?: true, on_delete: :delete
    end
  end

  actions do
    defaults [:read, :destroy]

    create :create do
      accept [:order, :name, :duration_seconds, :album_id]
      primary? true
    end

    update :update do
      accept [:order, :name, :duration_seconds]
      primary? true
    end
  end

  policies do
    policy always() do
      authorize_if accessing_from(Tunez.Music.Album, :tracks)
      authorize_if action_type(:read)
    end
  end

  preparations do
    prepare build(load: [:number])
  end

  attributes do
    uuid_primary_key :id

    attribute :order, :integer do
      allow_nil? false
      public? true
    end

    attribute :name, :string do
      allow_nil? false
      public? true
    end

    attribute :duration_seconds, :integer do
      allow_nil? false
      public? true
      constraints min: 1
    end

    create_timestamp :inserted_at, public?: true
    update_timestamp :updated_at, public?: true
  end

  relationships do
    belongs_to :album, Tunez.Music.Album do
      allow_nil? false
    end
  end

  calculations do
    calculate :number, :integer, expr(order + 1)
  end
end

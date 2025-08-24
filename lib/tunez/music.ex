defmodule Tunez.Music do
  use Ash.Domain,
    otp_app: :tunez

  resources do
    resource Tunez.Music.Artist do
      define :create_artist, action: :create
    end

    resource Tunez.Music.Artist do
      define :read_artists, action: :read
    end
  end
end

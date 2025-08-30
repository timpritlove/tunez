defmodule TunezWeb.AshJsonApiRouter do
  use AshJsonApi.Router,
    domains: [Tunez.Music, Tunez.Accounts],
    open_api: "/open_api",
    open_api_title: "Tunez API Documentation",
    open_api_description: "Get it all here where there is plenty of music",
    open_api_version: to_string(Application.spec(:tunez, :vsn))
end

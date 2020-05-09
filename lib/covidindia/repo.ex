defmodule Covidindia.Repo do
  use Ecto.Repo,
    otp_app: :covidindia,
    adapter: Ecto.Adapters.Postgres
end

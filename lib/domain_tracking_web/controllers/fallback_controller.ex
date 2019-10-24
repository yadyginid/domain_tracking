defmodule DomainTrackingFallbackController do
  use DomainTrackingWeb, :controller

  def call(conn,{:error, []}) do
    conn
    |> put_status(400)
    |>json(%{domains: [], status: "error parse string to integer"})
    end
end

defmodule DomainTrackingWeb.DomainController do
  use DomainTrackingWeb, :controller

  action_fallback DomainTrackingFallbackController

  def create(conn, %{"links" => links_params}) do
    insertToRedis(links_params)

    json(conn, %{status: "ok"})
  end

  def create(conn, _params) do
    conn
    |> put_status(400)
    |>json(%{status: "error params"})
  end

  def show(conn, %{"from" => from, "to" => to}) do
    with {:ok, from} <-parseString(from), {:ok, to} <-parseString(to) do
      {:ok, members} = Redix.command(:redix, ["ZRANGEBYSCORE", "redis_domens", from, to])
      domains = get_domains(members, [])

      json(conn, %{domains: Enum.uniq(domains), status: "ok"})
    end
  end

  def show(conn, _params) do
    conn
    |> put_status(400)
    |>json(%{domains: [], status: "error params"})
  end

  defp insertToRedis([head | tail]) do
    domen = parseUrl(head)

    unique_value = UUID.uuid4(:hex)

    Redix.command(:redix, ["ZADD", "redis_domens", :os.system_time(:seconds), to_string(unique_value)<>"-"<>domen.host])
    insertToRedis(tail)
  end

  defp insertToRedis([]), do: :ok

  defp parseUrl(url) do
    case URI.parse(url) do
      %URI{scheme: nil} -> parseUrl("http://#{url}")

      parsed -> parsed
    end
  end

  defp get_domains([head | tail], domains) do
    [head | _] = Regex.run(~r/[-]{1}.*+$/, head)
    [head | _] = Regex.run(~r/[^-]{1}.*+$/, head)

    get_domains(tail, [head | domains])
  end

  defp get_domains([], domains), do: domains

  defp parseString(value) do
    case Integer.parse(value) do
      {value, ""} -> {:ok, value}

      _ -> {:error, []}
    end
  end
end

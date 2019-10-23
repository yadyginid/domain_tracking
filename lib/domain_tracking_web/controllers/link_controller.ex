defmodule DomainTrackingWeb.DomainController do
  use DomainTrackingWeb, :controller

  def create(conn, %{"links" => links_params}) do
    insertToRedis(links_params)

    json(conn, %{status: "ok"})
  end

  def show(conn, %{"from" => from, "to" => to}) do
    {:ok, members} = Redix.command(:redix, ["ZRANGEBYSCORE", "new_table_controller_test", String.to_integer(from),String.to_integer(to)])
    domains = get_domains(members, [])

    json(conn, %{domains: Enum.uniq(domains), status: "ok"})
  end

  defp insertToRedis([head | tail]) do
    domen = parseUrl(head)

    unique_value = UUID.uuid4(:hex)
    Redix.command(:redix, ["ZADD", "new_table_controller_test", :os.system_time(:seconds), to_string(unique_value)<>"-"<>domen.host])
    insertToRedis(tail)
  end

  defp insertToRedis([]) do
    :ok
  end

  def parseUrl(url) do
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

  defp get_domains([], domains) do
    domains
  end
end

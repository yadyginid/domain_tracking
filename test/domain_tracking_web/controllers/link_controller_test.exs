defmodule DomainTrackingWeb.DomainControllerTest do
  @moduledoc false
  use DomainTrackingWeb.ConnCase

  describe "create" do
    test "создание записи в REDIS с валидными параметрами" do
      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} = HTTPoison.post "http://localhost:4000/api/visited_links", "{\"links\":[\"ya.ru\",\"funbox.ru\",\"stackoverflow.com\"]}", [{"Content-Type", "application/json"}]

      assert body == "{\"status\":\"ok\"}"
      assert status_code == 200
    end

    test "создание записи в REDIS с невалидными параметрами" do
      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} = HTTPoison.post "http://localhost:4000/api/visited_links", "{\"wrong\":[\"ya.ru\",\"funbox.ru\",\"stackoverflow.com\"]}", [{"Content-Type", "application/json"}]

      assert body == "{\"status\":\"error params\"}"
      assert status_code == 400
    end
  end

  describe "show" do
    test "просмотр записей REDIS с валидным запросом" do
      to =  Integer.to_string(:os.system_time(:seconds))
      url = "http://localhost:4000/api/visited_domains?from=1571838103&to=#{to}"
      {:ok, %HTTPoison.Response{status_code: status_code}} = HTTPoison.get(url)

      assert status_code == 200
    end

    test "просмотр записей REDIS с не валидным запросом" do
      to =  Integer.to_string(:os.system_time(:seconds))
      wrong_url = "http://localhost:4000/api/visited_domains?from=wrong1571838103&to=#{to}"
      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} = HTTPoison.get(wrong_url)

      assert body == "{\"domains\":[],\"status\":\"error parse string to integer\"}"
      assert status_code == 400
    end

    test "просмотр записей REDIS с не валидными параметрами" do
      to =  Integer.to_string(:os.system_time(:seconds))
      wrong_url = "http://localhost:4000/api/visited_domains?wrong=1571838103&to=#{to}"
      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} = HTTPoison.get(wrong_url)

      assert body == "{\"domains\":[],\"status\":\"error params\"}"
      assert status_code == 400
    end
  end
end

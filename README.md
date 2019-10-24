# DomainTracking
Просмотр посещенных доменов при помощи JSON API по HTTP, данные хранятся в  Redis
<h3>установка компонентов</h3>
<code>cd assets && npm install</code>
<h3>получение зависимостей</h3>
<code>mix deps.get</code>
<h3>запуск сервера</h3>
<code>iex -S mix phx.server</code>
<h3>добавление посещенных доменов</h3>
<code>HTTPoison.post "http://localhost:4000/api/visited_links", "{\"links\":[\"ya.ru\",\"funbox.ru\",\"stackoverflow.com\"]}", [{"Content-Type", "application/json"}]</code>
<h3>Просмотр доменов за интервал(from/to - это время :os.system_time(:seconds))</h3>
<code>HTTPoison.get("http://localhost:4000/api/visited_domains?from=1571838103&to=1581596983") </code>

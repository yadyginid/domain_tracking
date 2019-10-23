defmodule DomainTrackingWeb.DomainView do
  use DomainTrackingWeb, :view

  def render("new.json", %{status: status}) do
    %{status: status}
  end

  def render("show.json", %{domains: domains, status: status}) do
    %{domains: domains, status: status}
   # %{data: render_one(page, HelloWeb.PageView, "page.json")}
  end
end

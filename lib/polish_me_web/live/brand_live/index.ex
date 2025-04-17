defmodule PolishMeWeb.BrandLive.Index do
  use PolishMeWeb, :live_view

  alias PolishMe.Brands

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} title={@page_title}>
      <:actions :if={@current_scope.user.is_admin}>
        <.button variant="primary" navigate={~p"/brands/new"}>
          <.icon name="hero-plus" /> New Brand
        </.button>
      </:actions>

      <.table
        id="brands"
        rows={@streams.brands}
        row_click={fn {_id, brand} -> JS.navigate(~p"/brands/#{brand.slug}") end}
      >
        <:col :let={{_id, brand}} label="Name">{brand.name}</:col>
        <:col :let={{_id, brand}} label="Website">{uri_host(brand.website)}</:col>
        <:action :let={{_id, brand}}>
          <div class="sr-only">
            <.link navigate={~p"/brands/#{brand.slug}"}>Show</.link>
          </div>
          <.link
            :if={@current_scope.user.is_admin}
            id={"edit-brand-#{brand.slug}"}
            navigate={~p"/brands/#{brand.slug}/edit"}
          >
            <.icon name="hero-pencil" class="size-4 text-accent" />
          </.link>
        </:action>
      </.table>
    </Layouts.app>
    """
  end

  defp uri_host(website) when website in [nil, ""], do: nil

  defp uri_host(website) do
    {:ok, %URI{host: host}} = URI.new(website)

    host
  end

  @impl true
  def mount(_params, _session, socket) do
    Brands.subscribe()

    {:ok,
     socket
     |> assign(page_title: "Brands")
     |> stream(:brands, Brands.list_brands())}
  end

  @impl true
  def handle_info({type, %PolishMe.Brands.Brand{}}, socket)
      when type in [:created, :updated] do
    {:noreply, socket |> stream(:brands, Brands.list_brands(), reset: true)}
  end
end

defmodule PolishMeWeb.BrandLive.Show do
  use PolishMeWeb, :live_view

  alias PolishMe.Brands

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} title={@page_title}>
      <:actions>
        <.button navigate={~p"/brands"}>
          <.icon name="hero-arrow-left" />
        </.button>
        <.button
          :if={@current_scope.user.is_admin}
          variant="primary"
          navigate={~p"/brands/#{@brand.slug}/edit?return_to=show"}
        >
          <.icon name="hero-pencil-square" /> Edit
        </.button>
      </:actions>

      <.list>
        <:item title="Name">{@brand.name}</:item>
        <:item :if={@current_scope.user.is_admin} title="Slug">{@brand.slug}</:item>
        <:item title="Description">
          <span class="whitespace-pre-line">{@brand.description}</span>
        </:item>
        <:item title="Website">{@brand.website}</:item>
        <:item title="Contact Email">{@brand.contact_email}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"slug" => slug}, _session, socket) do
    brand = Brands.get_brand!(slug)
    Brands.subscribe(brand.id)

    {:ok, socket |> assign(page_title: brand.name, brand: brand)}
  end

  @impl true
  def handle_info({:updated, brand}, socket) do
    {:noreply, socket |> assign(brand: brand)}
  end
end

defmodule PolishMeWeb.BrandLive.Show do
  use PolishMeWeb, :live_view

  alias PolishMe.Brands
  alias PolishMe.Polishes

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app
      flash={@flash}
      title={if @brand.logo_url, do: nil, else: @page_title}
      subtitle={polish_count_text(@brand.polish_count)}
      image={@brand.logo_url}
    >
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
        <.button
          :if={@current_scope.user.is_admin}
          variant="primary"
          navigate={~p"/polishes/#{@brand.slug}/new"}
        >
          <.icon name="hero-plus" /> New Polish
        </.button>
        <.button navigate={~p"/polishes/#{@brand.slug}"}>
          All Polish <.icon name="hero-arrow-right" />
        </.button>
      </:actions>

      <.list>
        <:item title="Name">{@brand.name}</:item>
        <:item :if={@current_scope.user.is_admin} title="Slug">{@brand.slug}</:item>
        <:item title="Description">
          <span class="whitespace-pre-line">{@brand.description}</span>
        </:item>
        <:item title="Website">
          <.link href={@brand.website} class="text-info">
            {@brand.website}
          </.link>
        </:item>
        <:item title="Contact Email">
          <.link href={"mailto:#{@brand.contact_email}"} class="text-info">
            {@brand.contact_email}
          </.link>
        </:item>
      </.list>
    </Layouts.app>
    """
  end

  defp polish_count_text(1), do: "1 Polish"
  defp polish_count_text(x), do: "#{x} Polishes"

  @impl true
  def mount(%{"slug" => slug}, _session, socket) do
    brand = Brands.get_brand!(slug)
    Brands.subscribe_brand(brand.id)
    Polishes.subscribe_brand_polishes(brand.id)

    {:ok, socket |> assign(page_title: brand.name, brand: brand)}
  end

  @impl true
  def handle_info({:updated, brand}, socket) do
    {:noreply, socket |> assign(brand: brand)}
  end

  def handle_info({:created, _polish}, socket) do
    {:noreply, socket |> update(:brand, fn b -> Map.update!(b, :polish_count, &(&1 + 1)) end)}
  end
end

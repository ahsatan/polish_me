defmodule PolishMeWeb.PolishLive.Index do
  use PolishMeWeb, :live_view

  alias PolishMe.Brands
  alias PolishMe.Polishes
  alias PolishMe.Polishes.Polish
  alias PolishMeWeb.Helpers.TextHelpers

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} title={@page_title}>
      <:actions :if={@current_scope.user.is_admin}>
        <%= if @brand do %>
          <.button variant="primary" navigate={~p"/polishes/#{@brand.slug}/new"}>
            <.icon name="hero-plus" /> New {@brand.name} Polish
          </.button>
        <% else %>
          <.button variant="primary" navigate={~p"/polishes/new"}>
            <.icon name="hero-plus" /> New Polish
          </.button>
        <% end %>
      </:actions>

      <.table
        id="polishes"
        rows={@streams.polishes}
        row_click={
          fn {_id, polish} ->
            JS.navigate(~p"/polishes/#{polish.brand.slug}/#{polish.slug}")
          end
        }
      >
        <:col :let={{_id, polish}} label="Brand">{polish.brand.name}</:col>
        <:col :let={{_id, polish}} label="Name">{polish.name}</:col>
        <:col :let={{_id, polish}} label="Colors">
          {TextHelpers.enums_to_string(polish.colors, "<br />") |> raw()}
        </:col>
        <:col :let={{_id, polish}} label="Finishes">
          {TextHelpers.enums_to_string(polish.finishes, "<br />") |> raw()}
        </:col>
        <:col :let={{_id, polish}} label="Topper">
          <.icon :if={polish.topper} name="hero-check" class="text-info" />
        </:col>
        <:action :let={{_id, polish}}>
          <div class="sr-only">
            <.link navigate={~p"/polishes/#{polish.brand.slug}/#{polish.slug}"}>Show</.link>
          </div>
          <.link
            :if={@current_scope.user.is_admin}
            id={"edit-polish-#{polish.brand.slug}--#{polish.slug}"}
            navigate={~p"/polishes/#{polish.brand.slug}/#{polish.slug}/edit"}
          >
            <.icon name="hero-pencil" class="size-4 text-accent" />
          </.link>
        </:action>
      </.table>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    {:ok, socket |> apply_action(socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    Polishes.subscribe_all()

    socket
    |> assign(:page_title, "Polishes")
    |> assign(:brand, nil)
    |> stream(:polishes, Polishes.list_polishes())
  end

  defp apply_action(socket, :index_by_brand, %{"brand_slug" => brand_slug}) do
    brand = Brands.get_brand!(brand_slug)
    Polishes.subscribe_brand_polishes(brand.id)

    socket
    |> assign(:page_title, "#{brand.name} Polishes")
    |> assign(:brand, brand)
    |> stream(:polishes, Polishes.list_polishes(brand.id))
  end

  @impl true
  def handle_info({type, %Polish{}}, socket)
      when type in [:created, :updated] do
    update_polishes(socket, socket.assigns.brand)
  end

  defp update_polishes(socket, nil) do
    {:noreply, stream(socket, :polishes, Polishes.list_polishes(), reset: true)}
  end

  defp update_polishes(socket, brand) do
    {:noreply, stream(socket, :polishes, Polishes.list_polishes(brand.id), reset: true)}
  end
end

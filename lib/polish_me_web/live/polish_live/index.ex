defmodule PolishMeWeb.PolishLive.Index do
  use PolishMeWeb, :live_view

  alias PolishMe.Polishes
  alias PolishMeWeb.Helpers.TextHelpers

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} title={@page_title}>
      <:actions :if={@current_scope.user.is_admin}>
        <.button variant="primary" navigate={~p"/polishes/new"}>
          <.icon name="hero-plus" /> New Polish
        </.button>
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
  def mount(_params, _session, socket) do
    Polishes.subscribe()

    {:ok,
     socket
     |> assign(:page_title, "Polishes")
     |> stream(:polishes, Polishes.list_polishes())}
  end

  @impl true
  def handle_info({type, %PolishMe.Polishes.Polish{}}, socket)
      when type in [:created, :updated] do
    {:noreply, stream(socket, :polishes, Polishes.list_polishes(), reset: true)}
  end
end

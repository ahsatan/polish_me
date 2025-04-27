defmodule PolishMeWeb.PolishLive.Show do
  use PolishMeWeb, :live_view

  alias PolishMe.Polishes
  alias PolishMeWeb.Helpers.TextHelpers

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} title={@page_title}>
      <:actions>
        <.button navigate={~p"/polishes"}>
          <.icon name="hero-arrow-left" />
        </.button>
        <.button
          :if={@current_scope.user.is_admin}
          variant="primary"
          navigate={~p"/polishes/#{@polish.brand.slug}/#{@polish.slug}/edit?return_to=show"}
        >
          <.icon name="hero-pencil-square" /> Edit
        </.button>
      </:actions>

      <.list>
        <:item title="Name">{@polish.name}</:item>
        <:item :if={@current_scope.user.is_admin} title="Slug">{@polish.slug}</:item>
        <:item title="Description">
          <span class="whitespace-pre-line">{@polish.description}</span>
        </:item>
        <:item title="Colors">{TextHelpers.enums_to_string(@polish.colors)}</:item>
        <:item title="Finishes">{TextHelpers.enums_to_string(@polish.finishes)}</:item>
        <:item title="Topper">
          <.icon :if={@polish.topper} name="hero-check" class="text-info" />
        </:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"brand_slug" => brand_slug, "polish_slug" => polish_slug}, _session, socket) do
    polish = Polishes.get_polish!(brand_slug, polish_slug)
    Polishes.subscribe_polish(polish.id)

    {:ok, socket |> assign(page_title: "#{polish.brand.name}: #{polish.name}", polish: polish)}
  end

  @impl true
  def handle_info({:updated, polish}, socket) do
    {:noreply, socket |> assign(:polish, polish)}
  end
end

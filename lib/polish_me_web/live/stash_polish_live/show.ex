defmodule PolishMeWeb.StashPolishLive.Show do
  use PolishMeWeb, :live_view

  alias PolishMe.Stash
  alias PolishMeWeb.Helpers.TextHelpers

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} title={@page_title}>
      <:actions>
        <.button navigate={~p"/stash/polishes"}>
          <.icon name="hero-arrow-left" />
        </.button>
        <.button
          variant="primary"
          navigate={
            ~p"/stash/polishes/#{@stash_polish.polish.brand.slug}/#{@stash_polish.polish.slug}/edit?return_to=show"
          }
        >
          <.icon name="hero-pencil-square" /> Edit
        </.button>
      </:actions>

      <.list>
        <:item title="Status">{TextHelpers.atom_to_string(@stash_polish.status)}</:item>
        <:item title="Thoughts">{@stash_polish.thoughts}</:item>
        <:item title="Fill percent">
          <progress class="progress progress-info w-xl" value={@stash_polish.fill_percent} max="100" />
        </:item>
        <:item title="Purchase price">{@stash_polish.purchase_price}</:item>
        <:item title="Purchase date">
          {Calendar.strftime(@stash_polish.purchase_date, "%B %-d, %Y")}
        </:item>
        <:item title="Swatched">
          <.icon :if={@stash_polish.swatched} name="hero-check" class="text-success" />
        </:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"brand_slug" => brand_slug, "polish_slug" => polish_slug}, _session, socket) do
    stash_polish = Stash.get_stash_polish!(socket.assigns.current_scope, brand_slug, polish_slug)
    Stash.subscribe_polish(socket.assigns.current_scope, stash_polish.id)

    {:ok,
     socket
     |> assign(:page_title, "My #{stash_polish.polish.name}")
     |> assign(:stash_polish, stash_polish)}
  end

  @impl true
  def handle_info({:updated, stash_polish}, socket) do
    {:noreply, assign(socket, :stash_polish, stash_polish)}
  end

  def handle_info({:deleted, stash_polish}, socket) do
    {:noreply,
     socket
     |> put_flash(:error, "Stashed #{stash_polish.polish.name} was deleted.")
     |> push_navigate(to: ~p"/stash/polishes")}
  end
end

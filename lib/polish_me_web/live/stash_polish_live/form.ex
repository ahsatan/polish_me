defmodule PolishMeWeb.StashPolishLive.Form do
  use PolishMeWeb, :live_view

  alias PolishMe.Polishes
  alias PolishMe.Stash
  alias PolishMe.Stash.StashPolish
  alias PolishMeWeb.Helpers.TextHelpers

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} title={@page_title}>
      <.form for={@form} id="stash-polish-form" phx-change="validate" phx-submit="save">
        <.input
          field={@form[:status]}
          type="select"
          label="Status"
          prompt="Choose a value"
          options={Stash.get_statuses() |> TextHelpers.enums_to_string_map()}
        />
        <.input field={@form[:thoughts]} type="textarea" label="Thoughts" />
        <.input
          field={@form[:fill_percent]}
          type="range"
          label="Fill %"
          min="0"
          max="100"
          value={@form[:fill_percent].value}
          class="range range-accent"
        />
        <.input field={@form[:purchase_price]} label="Purchase $" />
        <.input field={@form[:purchase_date]} type="date" label="Purchase Date" />
        <.input field={@form[:swatched]} type="checkbox" label="Swatched" />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Stash polish</.button>
          <.button navigate={return_path(@current_scope, @return_to, @stash_polish)}>Cancel</.button>
        </footer>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  defp apply_action(socket, :edit, %{"brand_slug" => brand_slug, "polish_slug" => polish_slug}) do
    stash_polish = Stash.get_stash_polish!(socket.assigns.current_scope, brand_slug, polish_slug)

    socket
    |> assign(:page_title, "Edit My #{stash_polish.polish.name}")
    |> assign(:stash_polish, stash_polish)
    |> assign(
      :form,
      to_form(Stash.change_stash_polish(socket.assigns.current_scope, stash_polish))
    )
  end

  defp apply_action(socket, :new, %{"brand_slug" => brand_slug, "polish_slug" => polish_slug}) do
    polish = Polishes.get_polish!(brand_slug, polish_slug)

    stash_polish = %StashPolish{
      user_id: socket.assigns.current_scope.user.id,
      polish_id: polish.id,
      polish: polish
    }

    socket
    |> assign(:page_title, "New #{polish.name} Stash")
    |> assign(:stash_polish, stash_polish)
    |> assign(
      :form,
      to_form(Stash.change_stash_polish(socket.assigns.current_scope, stash_polish))
    )
  end

  @impl true
  def handle_event("validate", %{"stash_polish" => stash_polish_params}, socket) do
    changeset =
      Stash.change_stash_polish(
        socket.assigns.current_scope,
        socket.assigns.stash_polish,
        stash_polish_params
      )

    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"stash_polish" => stash_polish_params}, socket) do
    save_stash_polish(socket, socket.assigns.live_action, stash_polish_params)
  end

  defp save_stash_polish(socket, :edit, stash_polish_params) do
    case Stash.update_stash_polish(
           socket.assigns.current_scope,
           socket.assigns.stash_polish,
           stash_polish_params
         ) do
      {:ok, stash_polish} ->
        {:noreply,
         socket
         |> put_flash(:info, "Stash #{stash_polish.polish.name} updated successfully")
         |> push_navigate(
           to: return_path(socket.assigns.current_scope, socket.assigns.return_to, stash_polish)
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_stash_polish(socket, :new, stash_polish_params) do
    case Stash.create_stash_polish(
           socket.assigns.current_scope,
           stash_polish_params |> Map.put("polish_id", socket.assigns.stash_polish.polish_id)
         ) do
      {:ok, stash_polish} ->
        {:noreply,
         socket
         |> put_flash(:info, "Stash #{stash_polish.polish.name} created successfully")
         |> push_navigate(
           to: return_path(socket.assigns.current_scope, socket.assigns.return_to, stash_polish)
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path(_scope, "index", _stash_polish), do: ~p"/stash/polishes"

  defp return_path(_scope, "show", stash_polish),
    do: ~p"/stash/polishes/#{stash_polish.polish.brand.slug}/#{stash_polish.polish.slug}"
end

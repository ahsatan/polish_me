defmodule PolishMeWeb.BrandLive.Form do
  use PolishMeWeb, :live_view

  alias PolishMe.Brands
  alias PolishMe.Brands.Brand
  alias PolishMeWeb.Helpers.TextHelpers

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} title={@page_title}>
      <.form for={@form} id="brand-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:name]} id="name-input" type="text" label="Name" maxlength="60" required />
        <.input
          field={@form[:slug]}
          id="slug-input"
          type="text"
          label="Slug"
          maxlength="60"
          placeholder={TextHelpers.name_to_slug(@form[:name].value)}
          required
        />
        <.input
          field={@form[:description]}
          id="description-input"
          type="textarea"
          label="Description"
          phx-debounce="blur"
        />
        <.input
          field={@form[:website]}
          id="website-input"
          type="text"
          label="Website"
          placeholder="https://"
          maxlength="80"
        />
        <.input
          field={@form[:contact_email]}
          id="email-input"
          type="text"
          label="Contact Email"
          placeholder="support@brand.com"
          maxlength="80"
        />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save</.button>
          <.button navigate={return_path(@return_to, @brand)}>Cancel</.button>
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

  defp apply_action(socket, :edit, %{"slug" => slug}) do
    brand = Brands.get_brand!(slug)

    socket
    |> assign(:page_title, "Edit Brand")
    |> assign(:brand, brand)
    |> assign(:form, to_form(Brands.change_brand(brand)))
  end

  defp apply_action(socket, :new, _params) do
    brand = %Brand{}

    socket
    |> assign(:page_title, "New Brand")
    |> assign(:brand, brand)
    |> assign(:form, to_form(Brands.change_brand(brand)))
  end

  @impl true
  def handle_event("validate", %{"brand" => brand_params}, socket) do
    changeset = Brands.change_brand(socket.assigns.brand, brand_params)

    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"brand" => brand_params}, socket) do
    save_brand(socket, socket.assigns.live_action, brand_params)
  end

  defp save_brand(socket, :edit, brand_params) do
    case Brands.update_brand(socket.assigns.brand, brand_params) do
      {:ok, brand} ->
        {:noreply,
         socket
         |> put_flash(:info, "Brand #{brand.name} updated successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, brand))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_brand(socket, :new, brand_params) do
    case Brands.create_brand(brand_params) do
      {:ok, brand} ->
        {:noreply,
         socket
         |> put_flash(:info, "Brand #{brand.name} created successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, brand))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path("index", _brand), do: ~p"/brands"
  defp return_path("show", brand), do: ~p"/brands/#{brand.slug}"
end

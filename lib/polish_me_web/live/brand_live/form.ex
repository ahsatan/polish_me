defmodule PolishMeWeb.BrandLive.Form do
  use PolishMeWeb, :live_view

  alias PolishMe.Brands
  alias PolishMe.Brands.Brand
  alias PolishMeWeb.Helpers.TextHelpers

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app
      flash={@flash}
      title={if @brand.logo_url, do: nil, else: @page_title}
      image={@brand.logo_url}
    >
      <.form for={@form} id="brand-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:name]} id="name-input" type="text" label="Name" maxlength="60" required />
        <.input
          field={@form[:slug]}
          id="slug-input"
          type="text"
          label="Slug"
          maxlength="60"
          value={TextHelpers.name_to_slug(@form[:name].value)}
          disabled
        />
        <.input
          field={@form[:description]}
          id="description-input"
          type="textarea"
          label="Description"
          maxlength="1024"
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
        <fieldset class="fieldset mb-2">
          <label class="fieldset-label">Logo Image</label>
          <.live_file_input class="file-input" upload={@uploads.logo} />

          <%!-- Modified from: https://hexdocs.pm/phoenix_live_view/uploads.html --%>
          <%!-- phx-drop-target with the upload ref enables file drag and drop --%>
          <section phx-drop-target={@uploads.logo.ref}>
            <article :for={entry <- @uploads.logo.entries} class="upload-entry">
              <div :if={@uploads.logo.errors == []}>
                <figure>
                  <.live_img_preview width="320" entry={entry} />
                </figure>

                <%!-- entry.progress updates automatically for in-flight entries --%>
                <progress value={entry.progress} max="100" class="w-80">{entry.progress}%</progress>

                <button
                  type="button"
                  phx-click="cancel-upload"
                  phx-value-ref={entry.ref}
                  aria-label="cancel"
                >
                  &times;
                </button>
              </div>

              <p :for={err <- upload_errors(@uploads.logo, entry)} class="alert text-error">
                {error_to_string(err)}
              </p>
            </article>

            <p :for={err <- upload_errors(@uploads.logo)} class="alert text-error">
              {error_to_string(err)}
            </p>
          </section>
        </fieldset>

        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save</.button>
          <.button navigate={return_path(@return_to, @brand)}>Cancel</.button>
        </footer>
      </.form>
    </Layouts.app>
    """
  end

  defp error_to_string(:not_accepted),
    do: "Accepts only .jpg, .jpeg, .png, .svg, and .webp filetypes"

  defp error_to_string(:too_many_files), do: "You have selected too many files"
  defp error_to_string(:too_large), do: "The image is too large"
  defp error_to_string(:external_client_failure), do: "Something went terribly wrong"

  @impl true
  def mount(params, _session, socket) do
    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> allow_upload(:logo, accept: ~w(.jpg .jpeg .png .svg .webp), max_entries: 1)
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  defp apply_action(socket, :edit, %{"slug" => slug}) do
    brand = Brands.get_brand!(slug)

    socket
    |> assign(:page_title, "Edit #{brand.name}")
    |> assign(:uploaded_logo, brand.logo_url)
    |> assign(:brand, brand)
    |> assign(:form, to_form(Brands.change_brand(brand)))
  end

  defp apply_action(socket, :new, _params) do
    brand = %Brand{}

    socket
    |> assign(:page_title, "New Brand")
    |> assign(:uploaded_logo, nil)
    |> assign(:brand, brand)
    |> assign(:form, to_form(Brands.change_brand(brand)))
  end

  @impl true

  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :logo, ref)}
  end

  def handle_event("validate", %{"brand" => brand_params}, socket) do
    changeset = Brands.change_brand(socket.assigns.brand, brand_params)

    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"brand" => %{"name" => name} = brand_params}, socket) do
    slug = TextHelpers.name_to_slug(name)

    {:noreply, socket} =
      case uploaded_entries(socket, :logo) do
        {[%{client_type: type} = entry | _], _} ->
          logo_url =
            consume_uploaded_entry(socket, entry, fn %{path: path} ->
              dest =
                Path.join(
                  Application.app_dir(:polish_me, "priv/static/uploads/brand/logo"),
                  slug <> type_to_extension(type)
                )

              File.cp!(path, dest)
              {:ok, ~p"/uploads/brand/logo/#{Path.basename(dest)}"}
            end)

          {:noreply, socket |> assign(:uploaded_logo, logo_url)}

        _ ->
          {:noreply, socket}
      end

    brand_params =
      brand_params |> Map.put("slug", slug) |> Map.put("logo_url", socket.assigns.uploaded_logo)

    save_brand(socket, socket.assigns.live_action, brand_params)
  end

  defp type_to_extension("image/jpeg"), do: ".jpg"
  defp type_to_extension("image/png"), do: ".png"
  defp type_to_extension("image/svg+xml"), do: ".svg"
  defp type_to_extension("image/webp"), do: ".webp"

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

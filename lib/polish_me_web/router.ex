defmodule PolishMeWeb.Router do
  use PolishMeWeb, :router

  import PolishMeWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {PolishMeWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_scope_for_user
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :fetch_current_scope_for_user
  end

  scope "/", PolishMeWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  scope "/api", PolishMeWeb.API do
    pipe_through :api

    get "/brands", BrandController, :index
    get "/brands/:slug", BrandController, :show
    get "/polishes", PolishController, :index
    get "/polishes/:brand_slug", PolishController, :index_by_brand
    get "/polishes/:brand_slug/:polish_slug", PolishController, :show
  end

  scope "/api", PolishMeWeb.API do
    pipe_through [:api, :require_authenticated_user]

    get "/stash", StashController, :index
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:polish_me, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: PolishMeWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  scope "/", PolishMeWeb do
    pipe_through [:browser, :require_authenticated_user, :require_admin_user]

    live_session :require_admin_user,
      on_mount: [
        {PolishMeWeb.UserAuth, :require_authenticated},
        {PolishMeWeb.UserAuth, :require_admin}
      ] do
      live "/brands/new", BrandLive.Form, :new
      live "/brands/:slug/edit", BrandLive.Form, :edit
      live "/polishes/new", PolishLive.Form, :new
      live "/polishes/:brand_slug/new", PolishLive.Form, :new_by_brand
      live "/polishes/:brand_slug/:polish_slug/edit", PolishLive.Form, :edit
    end
  end

  scope "/", PolishMeWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{PolishMeWeb.UserAuth, :require_authenticated}] do
      live "/users/settings", UserLive.Settings, :edit
      live "/users/settings/confirm-email/:token", UserLive.Settings, :confirm_email

      live "/brands", BrandLive.Index, :index
      live "/brands/:slug", BrandLive.Show, :show

      live "/polishes", PolishLive.Index, :index
      live "/polishes/:brand_slug", PolishLive.Index, :index_by_brand
      live "/polishes/:brand_slug/:polish_slug", PolishLive.Show, :show

      live "/stash/polishes", StashPolishLive.Index, :index
      live "/stash/polishes/:brand_slug/:polish_slug/new", StashPolishLive.Form, :new
      live "/stash/polishes/:brand_slug/:polish_slug", StashPolishLive.Show, :show
      live "/stash/polishes/:brand_slug/:polish_slug/edit", StashPolishLive.Form, :edit
    end

    post "/users/update-password", UserSessionController, :update_password
  end

  scope "/", PolishMeWeb do
    pipe_through [:browser]

    live_session :current_user,
      on_mount: [{PolishMeWeb.UserAuth, :mount_current_scope}] do
      live "/users/register", UserLive.Registration, :new
      live "/users/log-in", UserLive.Login, :new
      live "/users/log-in/:token", UserLive.Confirmation, :new
    end

    post "/users/log-in", UserSessionController, :create
    delete "/users/log-out", UserSessionController, :delete
  end
end

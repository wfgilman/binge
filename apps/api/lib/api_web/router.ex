defmodule ApiWeb.Router do
  use ApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :api_auth do
    plug :accepts, ["json"]
    plug Api.AuthPipeline
  end

  scope "/api/v1", ApiWeb do
    pipe_through :api

    get "/dishes", DishController, :index
    post "/dishes/action", DishActionController, :create
    post "/users", UserController, :create
    post "/users/action", UserActionController, :create
    patch "/users/action", UserActionController, :update
  end

  scope "/api/v1", ApiWeb do
    pipe_through :api_auth

    post "/users/invite", UserController, :invite
    get "/users", UserController, :show
    get "/users/friends", UserController, :index
    delete "/users", UserController, :delete
  end
end

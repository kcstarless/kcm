Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  resources :registrations, only: [ :new, :create ]

  # Routes for all pages
  root to: redirect("/home")
  get "home", to: "pages#home", as: "home"

  scope path: "/visitus" do
    get "/", to: "pages#visitus", as: :visitus
    get "/parking", to: "pages#parking", as: :parking
  end

  scope path: "/ourtraders" do
    get "/", to: "pages#ourtraders", as: :ourtraders
  end

  scope path: "/becomeatrader" do
    get "/", to: "pages#becomeatrader", as: :becomeatrader
  end

  scope path: "/eventstours" do
    get "/", to: "pages#eventstours", as: :eventstours
  end

  scope path: "/news" do
    get "/", to: "pages#news", as: :news
  end

  scope path: "/thenightmarket" do
    get "/", to: "pages#thenightmarket", as: :thenightmarket
  end

  # General shop overview page
  scope path: "/shop" do
    get "/", to: "pages#shop", as: :shop
    get "/:id", to: "shops#show", as: :shopfront
  end

  resources :cart_items, only: [ :create, :update, :destroy ]

  resources :check_postcode, to: "delivery#check_postcode"
end

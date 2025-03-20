Rails.application.routes.draw do
  root to: redirect("/home")
  get "home", to: "pages#home", as: "home"
  # get "visitus", to: "pages#visitus", as: "visitus"
  get "ourtraders", to: "pages#ourtraders", as: "ourtraders"
  get "becomeatrader", to: "pages#becomeatrader", as: "becomeatrader"
  get "eventstours", to: "pages#eventstours", as: "eventstours"
  get "news", to: "pages#news", as: "news"
  get "thenightmarket", to: "pages#thenightmarket", as: "thenightmarket"

  scope path: "/visitus" do
    get "/", to: "pages#visitus", as: :visitus
    get "/parking", to: "pages#parking", as: :parking
  end
end

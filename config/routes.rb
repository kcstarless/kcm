Rails.application.routes.draw do
  root to: redirect("/home")
  get "home", to: "pages#home", as: "home"
  get "visitus", to: "pages#visitus", as: "visitus"
  get "ourtraders", to: "pages#ourtraders", as: "ourtraders"
end

class PagesController < ApplicationController
  allow_unauthenticated_access

  # Main menu pages
  def home
  end

  def visitus
    render template: "pages/visitus/index"
  end

  def ourtraders
    render template: "pages/ourtraders/index"
  end

  def eventstours
    render template: "pages/eventstours/index"
  end

  def shop
    @traders = Trader.includes(:shops).all # Ensure @traders is set
    render template: "pages/shop/index"
  end

  # Visit Us Submenu pages
  def parking
    render template: "pages/visitus/parking"
  end

  def form_delivery
    render partial: "shared/form_delivery"
  end
end

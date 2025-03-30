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

  def becomeatrader
    render template: "pages/becomeatrader/index"
  end

  def eventstours
    render template: "pages/eventstours/index"
  end

  def news
    render template: "pages/news/index"
  end

  def thenightmarket
    render template: "pages/thenightmarket/index"
  end

  def shop
    render template: "pages/shop/index"
  end

  # Visit Us Submenu pages
  def parking
    render template: "pages/visitus/parking"
  end
end

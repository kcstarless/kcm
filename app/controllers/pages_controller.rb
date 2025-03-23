class PagesController < ApplicationController
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

  # Visit Us Submenu pages
  def parking
    render template: "pages/visitus/parking"
  end
end

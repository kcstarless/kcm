class PagesController < ApplicationController
  # Main menu pages
  def home
  end

  def visitus
    render template: "pages/visitus/index"
  end

  def ourtraders
  end

  def becomeatrader
  end

  def eventstours
  end

  def news
  end

  def thenightmarket
  end

  # Visit Us Submenu pages
  def parking
    render "pages/visitus/parking"
  end
end

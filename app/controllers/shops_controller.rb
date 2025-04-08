class ShopsController < ApplicationController
  skip_before_action :require_authentication, only: [ :show ]

  def show
    @shop = Shop.find(params[:id])
    @products = @shop.products

    logger.debug "ShopSSSSSSSSS: #{@shop.inspect}" # Debug log to verify the shop object

    respond_to do |format|
      format.html do
        render partial: "pages/shop/traders_shop", locals: { shop: @shop, products: @products }
      end
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("card-container", partial: "pages/shop/traders_shop", locals: { shop: @shop, products: @products })
      end
    end
  end
end

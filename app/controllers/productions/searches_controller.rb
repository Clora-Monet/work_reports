class Productions::SearchesController < ApplicationController
  def index
    @production = Production.new
  end

  def search
    product_id = Product.find_by(code: params[:production][:product_id]).id
    @production_result = Production.search(params[:production][:date], params[:production][:line_id], product_id)
  end
end

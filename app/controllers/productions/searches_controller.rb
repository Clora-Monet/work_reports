class Productions::SearchesController < ApplicationController
  def index
    @production = Production.new

  end

  def search
    product_id = Product.find_by(code: params[:production][:product_id]).id
    @production = Production.search(params[:production][:date])
    # @production = Production.search(params[:production][:date], params[:production][:line_id], product_id)
  end

  private
  def search_params
    params.require(:production).permit(:date).merge(line_id: params[:line_id])
  end

end

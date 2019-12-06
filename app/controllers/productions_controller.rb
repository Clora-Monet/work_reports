class ProductionsController < ApplicationController
  before_action :set_line
  def index
    gon.date = ["7:00", "8:00", "9:00", "10:00", "11:00", "12:00", "13:00", "14:00", 
                "15:00", "16:00", "17:00", "18:00", "19:00", "20:00", "21:00", "22:00", 
                "23:00", "0:00", "1:00", "2:00", "3:00", "4:00", "5:00", "6:00"]
    gon.production = [200, 1400, 1200, 1200, 1600, 1400, 1200]
    gon.cumulative_production = [200, 1600, 2800, 4000, 5600, 7000, 8200]
    gon.prediction = [0,1400, 2800, 4200, 5600, 7000, 8400, 9800, 
                      11200, 12600, 14000, 15400, 16800, 18200, 19600, 21000,
                      22400, 23800, 25200, 26600, 28000, 29400, 30800, 32200]

    
    @production = Production.new
    @product = Product.new

  end

  def new
    
  end

  def create
    product_id = Product.find_by(code: params[:production][:product_id]).id
    Production.create(production_params.merge(product_id: product_id))
    @production = Production.new(production_params)
    redirect_to line_productions_path
  end

  def edit
    @production = Production.find(params[:id])
  end

  def update
  end
  
  def destroy
  end

  def show
  end

  private
  def production_params
    params.require(:production).permit(:date,
                                        :begin_box00, :begin_box01, :begin_box02, :begin_box03, :begin_box04, :begin_box05, :begin_box06, :begin_box07, 
                                        :begin_box08, :begin_box09, :begin_box10, :begin_box11, :begin_box12, :begin_box13, :begin_box14, :begin_box15, 
                                        :begin_box16, :begin_box17, :begin_box18, :begin_box19, :begin_box20, :begin_box21, :begin_box22, :begin_box23,
                                        :end_box00, :end_box01, :end_box02, :end_box03, :end_box04, :end_box05, :end_box06, :end_box07, 
                                        :end_box08, :end_box09, :end_box10, :end_box11, :end_box12, :end_box13, :end_box14, :end_box15, 
                                        :end_box16, :end_box17, :end_box18, :end_box19, :end_box20, :end_box21, :end_box22, :end_box23)
                                        .merge(line_id: params[:line_id])
                                        # product_id: Product.find_by(code: [:product_id]).id,
  end

  def set_line
    @line = Line.find(params[:line_id])
  end
end

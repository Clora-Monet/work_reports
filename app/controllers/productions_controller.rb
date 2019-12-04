class ProductionsController < ApplicationController
  # before_action :set_production, only: [:create]
  def index
    gon.date = ["am7:00", "am8:00", "am9:00", "am10:00", "am11:00", "am12:00", "pm1:00", "pm2:00", 
                "pm3:00", "pm4:00", "pm5:00", "pm6:00", "pm7:00", "pm8:00", "pm9:00", "pm10:00", 
                "pm11:00", "pm12:00", "am1:00", "am2:00", "am3:00", "am4:00", "am5:00", "am6:00"]
    gon.production = [200, 1400, 1200, 1200, 1600, 1400, 1200]
    gon.cumulative_production = [200, 1600, 2800, 4000, 5600, 7000, 8200]
    gon.prediction = [0,1400, 2800, 4200, 5600, 7000, 8400, 9800, 
                      11200, 12600, 14000, 15400, 16800, 18200, 19600, 21000,
                      22400, 23800, 25200, 26600, 28000, 29400, 30800, 32200]

    
    @begin_box = Production.new

  end

  def new
    
  end

  def create
    Production.create(production_params)
    @begin_box = Production.new(production_params)
    redirect_to root_path
  end

  def edit
    @begin_box = Production.find(params[:id])
  end

  def update
  end
  
  def destroy
  end

  def show
  end

  private
  def production_params
    params.require(:production).permit(:begin_box07, :begin_box08, :begin_box09)
  end

  # def set_production
  #   @begin_boxs = Production.find(params[:id])
  # end
end

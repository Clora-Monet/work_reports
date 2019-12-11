class ProductionsController < ApplicationController
  before_action :set_line

  def index
    gon.date = ["7:00", "8:00", "9:00", "10:00", "11:00", "12:00", "13:00", "14:00", 
                "15:00", "16:00", "17:00", "18:00", "19:00", "20:00", "21:00", "22:00", 
                "23:00", "0:00", "1:00", "2:00", "3:00", "4:00", "5:00", "6:00"]
    gon.production = [nil]
    gon.cumulative_production = [nil]
    gon.prediction = [nil]

    
    
    
    @production = Production.new

  end

  def new
    
  end

  def create
    product_id = Product.find_by(code: params[:production][:product_id]).id
    production_page = Production.create(production_params.merge(product_id: product_id))

    redirect_to edit_line_production_path(line_id: production_page.line_id, id:production_page.id)
  end

  def edit
    @production = Production.find(params[:id])
    gon.date = ["7:00", "8:00", "9:00", "10:00", "11:00", "12:00", "13:00", "14:00", 
                "15:00", "16:00", "17:00", "18:00", "19:00", "20:00", "21:00", "22:00", 
                "23:00", "0:00", "1:00", "2:00", "3:00", "4:00", "5:00", "6:00"]

    begin_boxs = []
    end_box = []
    begin_boxs = [@production.begin_box00,@production.begin_box01,@production.begin_box02,
                  @production.begin_box03,@production.begin_box04,@production.begin_box05,
                  @production.begin_box06,@production.begin_box07,@production.begin_box08,
                  @production.begin_box09,@production.begin_box10,@production.begin_box11,
                  @production.begin_box12,@production.begin_box13,@production.begin_box14,
                  @production.begin_box15,@production.begin_box16,
                  @production.begin_box17,@production.begin_box18,@production.begin_box19,
                  @production.begin_box20,@production.begin_box21,@production.begin_box22,
                  @production.begin_box23]
    end_boxs = [@production.end_box00,@production.end_box01,@production.end_box02,
                  @production.end_box03,@production.end_box04,@production.end_box05,
                  @production.end_box06,@production.end_box07,@production.end_box08,
                  @production.end_box09,@production.end_box10,@production.end_box11,
                  @production.end_box12,@production.end_box13,@production.end_box14,
                  @production.end_box15,@production.end_box16,
                  @production.end_box17,@production.end_box18,@production.end_box19,
                  @production.end_box20,@production.end_box21,@production.end_box22,
                  @production.end_box23]
    
    #No.1の箱までのnilの数
    begin_box_index = begin_boxs.index(1)

    #nilの除去
    begin_boxs_compact = begin_boxs.compact
    end_boxs_compact = end_boxs.compact

    #入れ目の取得
    per_case = @production.product.per_case

    #配列をpythonのnumpyの形にする
    begin_boxs_py = Numpy.array(begin_boxs_compact)
    end_boxs_py = Numpy.array(end_boxs_compact)

    #一時間あたりのできた箱数の計算
    #まずは差分を取る
    boxs_difference_py = end_boxs_py - begin_boxs_py
    boxs_difference = PyCall::List.(boxs_difference_py).to_a
    #差分が0のときはそのまま、0以外の時はプラス1をする。プラス1をしないと、正確な一時間にできた箱数にならない
    boxs_difference_plus = boxs_difference.map do |i|
      if i != 0
        i = i + 1
      else
        i
      end
    end

    #単回帰のための準備
    boxs_difference_plus_py = Numpy.array(boxs_difference_plus)
    per_boxs_cal = boxs_difference_plus_py 

    #一時間ごとの生産数(実数)
    day_productions = boxs_difference_plus_py * per_case

    #単回帰用に準備
    day_productions_cal = day_productions

    #pythonの配列からrubyの配列に変換
    @day_productions = PyCall::List.(day_productions).to_a
    
    #累計の計算(day_cumulative_productions=一時間ごとの生産数の累計)
    @day_cumulative_productions = @day_productions.size.times.map{|i| @day_productions[0..i].inject(:+)}

    #配列の先頭にnilを追加
    begin_box_index.times do |i|
      @day_productions.unshift(nil)
    end

    begin_box_index.times do |i|
      @day_cumulative_productions.unshift(nil)
    end

    #グラフに反映するために、gonに格納
    gon.day_productions = @day_productions
    gon.day_cumulative_productions = @day_cumulative_productions


    #単回帰分析
    #配列の用意
    x = []
    per_boxs_cal.size.times.map do |et|
      x.push(et)
      et = et + 1
    end

    per_boxs_cal = PyCall::List.(per_boxs_cal).to_a
    per_boxs_cumulative = per_boxs_cal.size.times.map{|i| per_boxs_cal[0..i].inject(:+)}

    x = Numpy.array(x)
    y = Numpy.array(per_boxs_cumulative)

    # #平均の算出
    # x = x.mean()
    # y = y.mean()

    #中心化
    xc = x - x.mean()
    yc = y - y.mean()

    #要素積
    xx = xc * xc
    xy = xc * yc

    xx.sum()
    xy.sum()

    #パラメータの決定
    a = xy.sum()/xx.sum()
    a = a.round

    #先頭の空白の部分を除いた分だけ、パラメータaが入った配列を用意する
    parameters = []
    (24 - begin_box_index).times.map do |es|
      parameters.push(a)
    end

    #パラメータが入った配列に入れ目をかける
    parameters_py = Numpy.array(parameters)
    parameters_per_case = parameters_py * per_case
    parameters_per_case = PyCall::List.(parameters_per_case).to_a
    #累計を計算する計算
    parameters_per_case_cumulative = parameters_per_case.size.times.map{|i| parameters_per_case[0..i].inject(:+)}
    #先頭の空白の分だけnilを配列の先頭に加える
    if begin_box_index == 0
      @productions_predict = parameters_per_case_cumulative
    else
      begin_box_index.times do |i|
        @productions_predict = parameters_per_case_cumulative.unshift(nil)
      end
    end
    #単回帰モデルの完成(productions_predict)
    gon.productions_predict = @productions_predict

    #縦軸の目盛間隔を入れ目と同じにするための準備
    gon.per_case = per_case

    @begin_box_index = begin_box_index
  end

  def update
    @production = Production.find(params[:id])
    if @production.update(production_params)
      redirect_to edit_line_production_path(line_id: @production.line_id, id: @production.id), notice: '更新しました'
    else
      render :edit
    end
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
  end

  def set_line
    @line = Line.find(params[:line_id])
  end
end

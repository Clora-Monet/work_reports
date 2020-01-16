class ProductionsController < ApplicationController
  include ApplicationHelper
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

    begin_boxs = [@production.begin_box1,@production.begin_box2,@production.begin_box3,
                  @production.begin_box4,@production.begin_box5,@production.begin_box6,
                  @production.begin_box7,@production.begin_box8,@production.begin_box9,
                  @production.begin_box10,@production.begin_box11,@production.begin_box12,
                  @production.begin_box13,@production.begin_box14,@production.begin_box15,
                  @production.begin_box16,@production.begin_box17,@production.begin_box18,
                  @production.begin_box19,@production.begin_box20,@production.begin_box21,
                  @production.begin_box22,@production.begin_box23,@production.begin_box24]
    end_boxs = [@production.end_box1,@production.end_box2,@production.end_box3,
                @production.end_box4,@production.end_box5,@production.end_box6,
                @production.end_box7,@production.end_box8,@production.end_box9,
                @production.end_box10,@production.end_box11,@production.end_box12,
                @production.end_box13,@production.end_box14,@production.end_box15,
                @production.end_box16,@production.end_box17,@production.end_box18,
                @production.end_box19,@production.end_box20,@production.end_box21,
                @production.end_box22,@production.end_box23,@production.end_box24]
    
    #No.1の箱までのnilの数
    begin_box_index = begin_boxs.index(1)

    #nilの除去
    begin_boxs_compact = begin_boxs.compact
    end_boxs_compact = end_boxs.compact

    #入れ目の取得
    per_case = @production.product.per_case

    #一時間あたりのできた箱数の計算
    #まずは差分を取る
    @boxs_difference = []
    end_boxs_compact.zip(begin_boxs_compact).each do |end_box, begin_box|
      box_difference = end_box - begin_box
      @boxs_difference.push(box_difference)
    end
    
    #差分が0のときはそのまま、0以外の時はプラス1をする。プラス1をしないと、正確な一時間にできた箱数にならない
    boxs_difference_plus = @boxs_difference.map do |i|
      if i != 0
        i = i + 1
      else
        i
      end
    end

    #下で.sizeメソッドを使うための準備
    per_boxs_cal = boxs_difference_plus

    #一時間ごとの生産数(実数)
    @day_productions = []
    boxs_difference_plus.each do |b|
      number = b * per_case
      @day_productions.push(number)
    end

    #単回帰用に準備
    day_productions_cal = @day_productions
    
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


    # 単回帰分析
    # 横軸xのための配列の用意
    xs = []
    per_boxs_cal.size.times.map do |x|
      xs.push(x)
      x = x + 1
    end

    #累計の算出
    per_boxs_cumulative = per_boxs_cal.size.times.map{|i| per_boxs_cal[0..i].inject(:+)}

    if per_boxs_cal.size > 1
      ys = per_boxs_cumulative

      #xとyの平均値を求める
      x_mean = xs.inject(:+) / xs.length
      y_mean = ys.inject(:+) / ys.length

      #中心化
      @xcs = []
      @ycs = []

      xs.each do |x|
        xc = x - x_mean
        @xcs.push(xc)
      end

      ys.each do |y|
        yc = y - y_mean
        @ycs.push(yc)
      end
      
      #要素積
      @xxs = []
      @xys = []

      @xcs.zip(@xcs).each do |xc_1, xc_2|
        xx = xc_1 * xc_2
        @xxs.push(xx)
      end

      @xcs.zip(@ycs).each do |xc, yc|
        xy = xc * yc
        @xys.push(xy)
      end

      # パラメータの決定
      a = @xys.sum/@xxs.sum
      #パラメータの四捨五入(aが少数になると、予測する生産数が少数になるため)
      a = a.round
    else
      a = per_boxs_cal[0] + 1
    end
    
    # #先頭の空白の部分を除いた分だけ、パラメータaが入った配列を用意する
    # parameters = []
    # (24 - begin_box_index).times.map do |es|
    #   parameters.push(a)
    # end

    # #パラメータが入った配列に入れ目をかける
    # parameters_py = Numpy.array(parameters)
    # parameters_per_case = parameters_py * per_case
    # parameters_per_case = PyCall::List.(parameters_per_case).to_a
    # #累計を計算する計算
    # parameters_per_case_cumulative = parameters_per_case.size.times.map{|i| parameters_per_case[0..i].inject(:+)}
    # #先頭の空白の分だけnilを配列の先頭に加える
    # if begin_box_index == 0
    #   @productions_predict = parameters_per_case_cumulative
    # else
    #   begin_box_index.times do |i|
    #     @productions_predict = parameters_per_case_cumulative.unshift(nil)
    #   end
    # end
    # #単回帰モデルの完成(productions_predict)
    # gon.productions_predict = @productions_predict

    # #縦軸の目盛間隔を入れ目と同じにするための準備
    # gon.per_case = per_case

    # @begin_box_index = begin_box_index
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
                                        :begin_box1, :begin_box2, :begin_box3, :begin_box4, :begin_box5, :begin_box6, :begin_box7, :begin_box8,  
                                        :begin_box9, :begin_box10, :begin_box11, :begin_box12, :begin_box13, :begin_box14, :begin_box15,:begin_box16, 
                                        :begin_box17, :begin_box18, :begin_box19, :begin_box20, :begin_box21, :begin_box22, :begin_box23, :begin_box24,
                                        :end_box1, :end_box2, :end_box3, :end_box4, :end_box5, :end_box6, :end_box7, :end_box8,
                                        :end_box9, :end_box10, :end_box11, :end_box12, :end_box13, :end_box14, :end_box15, :end_box16,
                                        :end_box17, :end_box18, :end_box19, :end_box20, :end_box21, :end_box22, :end_box23, :end_box24)
                                        .merge(line_id: params[:line_id])
  end

  def set_line
    @line = Line.find(params[:line_id])
  end
end
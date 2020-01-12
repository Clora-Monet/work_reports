class Productions::SearchesController < ApplicationController
  def index
    @production = Production.new
  end

  def search
    product_id = Product.find_by(code: params[:production][:product_id]).id
    @production_result = Production.search(params[:production][:date], params[:production][:line_id], product_id)

    gon.date = ["7:00", "8:00", "9:00", "10:00", "11:00", "12:00", "13:00", "14:00", 
                "15:00", "16:00", "17:00", "18:00", "19:00", "20:00", "21:00", "22:00", 
                "23:00", "0:00", "1:00", "2:00", "3:00", "4:00", "5:00", "6:00"]

  begin_boxs = [@production_result.begin_box1,@production_result.begin_box2,@production_result.begin_box3,
                @production_result.begin_box4,@production_result.begin_box5,@production_result.begin_box6,
                @production_result.begin_box7,@production_result.begin_box8,@production_result.begin_box9,
                @production_result.begin_box10,@production_result.begin_box11,@production_result.begin_box12,
                @production_result.begin_box13,@production_result.begin_box14,@production_result.begin_box15,
                @production_result.begin_box16,@production_result.begin_box17,@production_result.begin_box18,
                @production_result.begin_box19,@production_result.begin_box20,@production_result.begin_box21,
                @production_result.begin_box22,@production_result.begin_box23,@production_result.begin_box24]
  end_boxs = [@production_result.end_box1,@production_result.end_box2,@production_result.end_box3,
              @production_result.end_box4,@production_result.end_box5,@production_result.end_box6,
              @production_result.end_box7,@production_result.end_box8,@production_result.end_box9,
              @production_result.end_box10,@production_result.end_box11,@production_result.end_box12,
              @production_result.end_box13,@production_result.end_box14,@production_result.end_box15,
              @production_result.end_box16,@production_result.end_box17,@production_result.end_box18,
              @production_result.end_box19,@production_result.end_box20,@production_result.end_box21,
              @production_result.end_box22,@production_result.end_box23,@production_result.end_box24]

    #No.1の箱までのnilの数
    begin_box_index = begin_boxs.index(1)

    #nilの除去
    begin_boxs_compact = begin_boxs.compact
    end_boxs_compact = end_boxs.compact

    #入れ目の取得
    per_case = @production_result.product.per_case

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

    #Numpy型にする
    boxs_difference_plus_py = Numpy.array(boxs_difference_plus)
    #一時間ごとの生産数(実数)
    day_productions = boxs_difference_plus_py * per_case
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
    gon.result_date = @production_result.date.strftime("%Y年%m月%d日")

  end
end

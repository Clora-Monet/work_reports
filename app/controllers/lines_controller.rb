class LinesController < ApplicationController
  # before_action :set_line
  def index
    @line = Line.new
    @lines = Line.all
  end

  private

  # def set_line
  #   @line = Line.find(params[:id])
  # end
end

class Productions::SearchesController < ApplicationController
  def index
    @production = Production.new
  end
end

class LogsController < ApplicationController
  def index
    @months = Month.order(:name)
    respond_to do |format|
      format.html
      format.csv{ send_data @months.to_csv }
    end
  end
end

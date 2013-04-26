class LogPresenter < BasePresenter
  def months _months
    h.render 'months/months', months:_months
  end
end

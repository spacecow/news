require 'spec_helper'

describe LogPresenter do
  let(:log){ mock_model Log }
  let(:presenter){ LogPresenter.new(log,view) }
  subject{ rendering }

  describe '#months' do
    let(:month){ create :month }
    let(:rendering){ Capybara.string presenter.months [month]}
    it{ should have_selector 'div.months' }
  end
end

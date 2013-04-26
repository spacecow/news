require 'spec_helper'

describe MonthPresenter do
  let(:month){ stub_model Month }
  let(:presenter){ MonthPresenter.new(month,view) }

  describe '#categories' do
    let(:category){ create :category }
    before{ month.should_receive(:categories).and_return [category] }
    subject{ Capybara.string presenter.categories }
    it{ should have_selector 'ul.categories' }
  end

  describe '#months' do
    subject{ Capybara.string presenter.months [month,month]}
    it{ should have_selector 'div.month', count:2 }
  end

  describe '#subtitle' do
    before{ month.should_receive(:title).and_return 'October 2011' }
    subject{ Capybara.string presenter.subtitle }
    its(:text){ should eq 'October 2011' }
  end
end

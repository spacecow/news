require 'spec_helper'

describe CategoryPresenter do
  let(:category){ mock_model Category }
  let(:presenter){ CategoryPresenter.new(category,view) }

  describe '#categories' do
    before{ category.stub(:name){ 'pdf01' }}
    subject{ Capybara.string presenter.categories [category]}
    it{ should have_selector 'li.category' }
  end

  describe '#counts' do
    context "pdf match" do
      before do
        category.should_receive(:name).and_return 'pdf01'
        category.should_receive(:log_count).and_return '1'
        category.should_receive(:unique_log_count).and_return '2'
      end
      subject{ Capybara.string presenter.counts }
      its(:text){ should eq 'Pdf01 downloads: 1 (2)' }
    end

    context "top page match" do
      before do
        category.should_receive(:name).and_return 'page_top'
        category.should_receive(:log_count).and_return '1'
        category.should_receive(:unique_log_count).and_return '1'
      end
      subject{ Capybara.string presenter.counts }
      its(:text){ should eq 'Top page hits: 1 (1)' }
    end

    context "no other match" do
      before{ category.should_receive(:name).and_return 'other' }
      specify{ lambda{ Capybara.string presenter.counts }.should raise_error AssertionFailure }
    end
  end
end

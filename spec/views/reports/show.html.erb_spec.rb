require 'rails_helper'

RSpec.describe 'reports/show', type: :view do
  fixtures :all

  context 'order with report is assigned' do
    before do
      assign(:report, reports(:report))
      render
    end

    it 'displays specific report comment' do
      expect(rendered).to include('brake fluid must be changed')
    end

    it 'displays specific report car mileage' do
      expect(rendered).to include('10000')
    end

    it 'displays Back button' do
      expect(rendered).to include('Back')
    end
  end
end

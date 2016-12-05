require 'rails_helper'

RSpec.describe 'orders/index', type: :view do
  fixtures :all

  context 'when flash error does not exist' do
    before do
      assign(:orders, [orders(:ongoing_order), orders(:completed_order)])
      render
    end

    it 'does not render alert class' do
      expect(rendered).not_to include('alert alert-danger')
    end

    it 'displays all orders' do
      expect(rendered).to include('2016-11-11')
      expect(rendered).to include('2016-10-10')
    end

    it 'displays New order button' do
      expect(rendered).to include('New order')
    end
  end

  context 'when flash error is present' do
    before do
      assign(:orders, [orders(:ongoing_order), orders(:completed_order)])
      flash[:error] = 'flash error'
      render
    end

    it 'renders alert class' do
      expect(rendered).to include('alert alert-danger')
    end

    it 'displays specific flash error message' do
      expect(rendered).to include('flash error')
    end
  end
end

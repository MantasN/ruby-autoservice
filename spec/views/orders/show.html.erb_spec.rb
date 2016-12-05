require 'rails_helper'

RSpec.describe 'orders/show', type: :view do
  fixtures :all

  context 'order does not have report' do
    before do
      assign(:order, orders(:ongoing_order))
      render
    end

    it 'displays Assign button' do
      expect(rendered).to include('Assign')
    end

    it 'does not display Show button' do
      expect(rendered).not_to include('Show')
    end

    it 'does not display Delete button' do
      expect(rendered).not_to include('Delete')
    end
  end

  context 'order have assigned report' do
    before do
      assign(:order, orders(:completed_order))
      render
    end

    it 'does not display Assign button' do
      expect(rendered).not_to include('Assign')
    end

    it 'displays Show button' do
      expect(rendered).to include('Show')
    end

    it 'displays Delete button' do
      expect(rendered).to include('Delete')
    end
  end

  context 'order is assigned' do
    before do
      assign(:order, orders(:ongoing_order))
      render
    end

    it 'displays specific order repair date' do
      expect(rendered).to include('2016-11-11')
    end

    it 'displays specific order state' do
      expect(rendered).to include('ongoing')
    end

    it 'displays specific order reason' do
      expect(rendered).to include('need to change tires')
    end

    it 'displays specific order car' do
      expect(rendered).to include('VW GOLF 6')
    end

    it 'displays specific order owner' do
      expect(rendered).to include('Mantas Neviera')
    end
  end

  context 'when flash error does not exist' do
    before do
      assign(:order, orders(:ongoing_order))
      render
    end

    it 'does not render alert class' do
      expect(rendered).not_to include('alert alert-danger')
    end
  end

  context 'when flash error is present' do
    before do
      assign(:order, orders(:ongoing_order))
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

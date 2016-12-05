require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  fixtures :all

  let(:order_valid_params) do
    { 'date(1i)': '2016',
      'date(2i)': '12',
      'date(3i)': '12',
      'detail_attributes': { 'reason': 'reason', 'car': 'car',
                             'owner': 'owner' } }
  end

  let(:order_invalid_params) do
    { 'date(1i)': '2016',
      'date(2i)': '12',
      'date(3i)': '12',
      'detail_attributes': { 'reason': '', 'car': '', 'owner': '' } }
  end

  context 'PUT #update' do
    context 'with valid attributes' do
      it 'do not change count of orders' do
        expect do
          process :update, params: { id: orders(:pending_order),
                                     order: order_valid_params }
        end.to_not change(Order, :count)
      end

      before do
        process :update, params: { id: orders(:pending_order),
                                   order: order_valid_params }
      end

      it 'responds with an HTTP 302 status code' do
        expect(response).to have_http_status(302)
      end

      it 'redirects to order' do
        expect(response).to redirect_to(orders(:pending_order))
      end

      it 'must return updated reason' do
        expect(orders(:pending_order).detail.reason).to eq('reason')
      end
    end

    context 'with invalid attributes' do
      it 'do not change count of orders' do
        expect do
          process :update, params: { id: orders(:pending_order),
                                     order: order_invalid_params }
        end.to_not change(Order, :count)
      end

      before do
        process :update, params: { id: orders(:pending_order),
                                   order: order_invalid_params }
      end

      it 'renders the edit template' do
        expect(response).to render_template('edit')
      end

      it 'detail must be nil' do
        expect(orders(:pending_order).detail).to be_nil
      end
    end
  end

  context 'POST #create' do
    context 'with valid attributes' do
      it 'save new order' do
        expect do
          process :create, params: { order: order_valid_params }
        end.to change(Order, :count).by(1)
      end

      before do
        process :create, params: { order: order_valid_params }
      end

      it 'responds with an HTTP 302 status code' do
        expect(response).to have_http_status(302)
      end

      it 'do not render new template' do
        expect(response).to_not render_template('new')
      end
    end

    context 'with invalid attributes' do
      it 'renders the new template' do
        process :create, params: { order: order_invalid_params }
        expect(response).to render_template('new')
      end

      it 'do not save new order' do
        expect do
          process :create, params: { order: order_invalid_params }
        end.to_not change(Order, :count)
      end
    end
  end

  context 'GET #edit' do
    context 'if order have pending state' do
      before do
        process :edit, params: { id: orders(:pending_order) }
      end

      it 'responds successfully with an HTTP 200 status code' do
        expect(response).to have_http_status(200)
      end

      it 'renders the edit template' do
        expect(response).to render_template('edit')
      end

      it 'assigns the requested order to @order' do
        expect(assigns(:order)).to eq(orders(:pending_order))
      end

      it 'do not fill flash[:error]' do
        expect(flash[:error]).to be_nil
      end
    end

    context 'if order have ongoing state' do
      before do
        process :edit, params: { id: orders(:ongoing_order) }
      end

      it 'responds with an HTTP 302 status code' do
        expect(response).to have_http_status(302)
      end

      it 'redirects to orders_path' do
        expect(response).to redirect_to(orders_path)
      end

      it 'fill flash[:error]' do
        expect(flash[:error]).to eq('Only pending order can be edited')
      end
    end
  end

  context 'GET #index' do
    before do
      process :index
    end

    it 'responds with an HTTP 200 status code' do
      expect(response).to have_http_status(200)
    end

    it 'renders the index template' do
      expect(response).to render_template('index')
    end

    it 'loads all orders' do
      expect(assigns(:orders)).to match_array(Order.all)
    end
  end

  context 'GET #show' do
    before do
      process :show, params: { id: orders(:pending_order) }
    end

    it 'assigns the requested order to @order' do
      expect(assigns(:order)).to eq(orders(:pending_order))
    end

    it 'renders the show template' do
      expect(response).to render_template('show')
    end

    it 'responds with an HTTP 200 status code' do
      expect(response).to have_http_status(200)
    end
  end

  context 'GET #new' do
    before do
      process :new
    end

    it 'assigns new order' do
      expect(assigns(:order)).to be_new_record
    end

    it 'renders the new template' do
      expect(response).to render_template('new')
    end

    it 'responds with an HTTP 200 status code' do
      expect(response).to have_http_status(200)
    end
  end

  context 'DELETE #destroy' do
    it 'deletes the order' do
      expect do
        process :destroy, params: { id: orders(:pending_order) }
      end.to change(Order, :count).by(-1)
    end

    it 'redirects to orders_path' do
      process :destroy, params: { id: orders(:pending_order) }
      expect(response).to redirect_to(orders_path)
    end

    it 'responds with an HTTP 302 status code' do
      process :destroy, params: { id: orders(:pending_order) }
      expect(response).to have_http_status(302)
    end
  end
end

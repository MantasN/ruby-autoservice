require 'rails_helper'

RSpec.describe ReportsController, type: :controller do
  fixtures :all

  context 'POST #create' do
    context 'with valid attributes' do
      context 'if order have ongoing state' do
        let(:order_params) do
          { order_id: orders(:ongoing_order), report:
              { 'comment': 'comment', 'car_mileage': '10000' } }
        end

        before do
          process :create, params: order_params
        end

        it 'responds with an HTTP 302 status code' do
          expect(response).to have_http_status(302)
        end

        it 'do not render new template' do
          expect(response).to_not render_template('new')
        end

        it 'redirects to @order' do
          expect(response).to redirect_to(orders(:ongoing_order))
        end

        it 'save new report' do
          expect(orders(:ongoing_order).report).to_not be_nil
        end
      end
    end

    context 'with invalid attributes' do
      let(:order_params) do
        { order_id: orders(:ongoing_order), report:
            { 'comment': 'comment', 'car_mileage': '-1' } }
      end

      before do
        process :create, params: order_params
      end

      it 'render new template' do
        expect(response).to render_template('new')
      end

      it 'do not save new report' do
        expect(orders(:ongoing_order).report).to be_nil
      end
    end

    context 'must check state before creating report' do
      let(:ongoing_order_params) do
        { order_id: orders(:ongoing_order), report:
            { 'comment': 'comment', 'car_mileage': '10000' } }
      end

      let(:pending_order_params) do
        { order_id: orders(:pending_order), report:
            { 'comment': 'comment', 'car_mileage': '10000' } }
      end

      it 'Report creation must be skipped if state pending' do
        expect(Report).not_to receive(:new)
        process :create, params: pending_order_params
      end

      it 'Report must be created if state is ongoing' do
        expect(Report).to receive(:new).once.and_call_original
        process :create, params: ongoing_order_params
      end
    end
  end

  context 'GET #show' do
    before do
      process :show, params: { order_id: orders(:completed_order) }
    end

    it 'assigns the requested report to @report' do
      expect(assigns(:report)).to eq(orders(:completed_order).report)
    end

    it 'renders the show template' do
      expect(response).to render_template('show')
    end

    it 'responds with an HTTP 200 status code' do
      expect(response).to have_http_status(200)
    end
  end

  context 'GET #new' do
    context 'if order have completed state' do
      before do
        process :new, params: { order_id: orders(:completed_order) }
      end

      it 'assigns order passed as param' do
        expect(assigns(:order)).to eq(orders(:completed_order))
      end

      it 'assigns new report' do
        expect(assigns(:report)).to be_new_record
      end

      it 'do not render the new template' do
        expect(response).to_not render_template('new')
      end

      it 'redirects to @order' do
        expect(response).to redirect_to(orders(:completed_order))
      end

      it 'fill flash[:error]' do
        expect(flash[:error])
          .to eq('Report can only be assigned to ongoing order')
      end
    end

    context 'if order have ongoing state' do
      before do
        process :new, params: { order_id: orders(:ongoing_order) }
      end

      it 'assigns order passed as param' do
        expect(assigns(:order)).to eq(orders(:ongoing_order))
      end

      it 'assigns new report' do
        expect(assigns(:report)).to be_new_record
      end

      it 'renders the new template' do
        expect(response).to render_template('new')
      end

      it 'responds with an HTTP 200 status code' do
        expect(response).to have_http_status(200)
      end

      it 'do not fill flash[:error]' do
        expect(flash[:error]).to be_nil
      end
    end
  end

  context 'DELETE #destroy' do
    it 'deletes the report' do
      expect do
        process :destroy, params: { order_id: orders(:completed_order) }
      end.to change(Report, :count).by(-1)
    end

    it 'redirects to @order' do
      process :destroy, params: { order_id: orders(:completed_order) }
      expect(response).to redirect_to(orders(:completed_order))
    end

    it 'responds with an HTTP 302 status code' do
      process :destroy, params: { order_id: orders(:completed_order) }
      expect(response).to have_http_status(302)
    end
  end
end

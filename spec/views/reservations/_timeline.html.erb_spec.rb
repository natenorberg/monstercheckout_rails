require 'rails_helper'

RSpec.describe 'reservations/_timeline', :type => :view do
  before(:each) do
    @out_time = 1.days.ago
    @in_time = 1.days.from_now
    @user = FactoryGirl.create(:user)    
    @reservation = assign(:reservation, Reservation.create!(
      :user_id => @user.id,
      :project => 'Project',
      :out_time => @out_time,
      :in_time => @in_time,
      :is_approved => false,
    ))  
    view.stub(:auto_shrink_date).with(@reservation.created_at).and_return 'Created Date'
  end

  it 'renders submitted date' do
    render partial: 'reservations/timeline'

    assert_select 'li.list-group-item>strong.status-text-requested'
    assert_select 'li.list-group-item', text: /Created Date/
  end

  describe 'updated record' do
    before(:each) do
      @reservation.updated_at = Time.now
      @reservation.status = :requested
      view.stub(:auto_shrink_date).with(@reservation.updated_at).and_return 'Updated Date'
    end

    it 'renders updated date' do
      render partial: 'reservations/timeline'

      assert_select 'li.list-group-item>strong.status-text-updated'
      assert_select 'li.list-group-item', text: /Updated Date/
    end
  end

  describe 'approved record' do
    before(:each) do
      @reservation.is_approved = true
      @reservation.admin_response_time = Time.now
      view.stub(:auto_shrink_date).with(@reservation.admin_response_time).and_return 'Approved Date'
    end

    it 'renders approved date' do
      render partial: 'reservations/timeline'

      assert_select 'li.list-group-item>strong.status-text-approved'
      assert_select 'li.list-group-item', text: /Approved Date/
    end

    describe 'checked out record' do
      before do 
        @reservation.checked_out_time = Time.now
        @monitor = FactoryGirl.create(:monitor)
        @reservation.checked_out_by_id = @monitor.id
        @reservation.check_out_comments = 'Checkout comments'
        view.stub(:auto_shrink_date).with(@reservation.checked_out_time).and_return 'Checkout Date'
      end

      it 'renders checkout info' do
        render partial: 'reservations/timeline'

        assert_select 'li.list-group-item>strong.status-text-out'
        assert_select 'li.list-group-item', text: /Checkout Date/
        assert_select 'li.list-group-item>.timeline-monitor-info' do
          
          assert_select 'h4.timeline-monitor-name', :text => @monitor.name
          assert_select '.timeline-comments', :text => /Checkout comments/
        end
      end

      describe 'returned record' do
        before do 
          @reservation.checked_in_time = Time.now
          @reservation.checked_in_by_id = @monitor.id
          @reservation.check_in_comments = 'Checkin comments'
          view.stub(:auto_shrink_date).with(@reservation.checked_in_time).and_return 'Checkin Date'
        end

        it 'renders checkin info' do
          render partial: 'reservations/timeline'

          assert_select 'li.list-group-item>strong.status-text-returned'
          assert_select 'li.list-group-item', text: /Checkin Date/
          assert_select 'li.list-group-item>.timeline-monitor-info' do
            
            assert_select 'h4.timeline-monitor-name', :text => @monitor.name
            assert_select '.timeline-comments', :text => /Checkin comments/
          end          
        end

        describe 'late' do
          before do 
            @reservation.stub(:returned_late?).and_return true
          view.stub(:auto_shrink_date).with(@reservation.in_time).and_return 'Due Date'
          end

          it 'should render the due date' do
            render partial: 'reservations/timeline'

            assert_select 'li.list-group-item>strong.status-text-returned_late'
            assert_select 'li.list-group-item', :text => /Due Date/
          end
        end
      end
    end
  end

  describe 'denied record' do
    let(:reason) { 'Because I said so' }
    before(:each) do
      @reservation.is_denied = true
      @reservation.admin_response_time = Time.now
      @reservation.denied_reason = reason
      view.stub(:auto_shrink_date).with(@reservation.admin_response_time).and_return 'Denied Date'
    end

    it 'renders denied date' do
      render partial: 'reservations/timeline'

      assert_select 'li.list-group-item>strong.status-text-denied'
      assert_select 'li.list-group-item', text: /Denied Date/
      expect(rendered).to match(reason)
    end
  end
end
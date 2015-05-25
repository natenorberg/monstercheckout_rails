require 'rails_helper'

def check_item(item, quantity=nil)
  find(:css, "#reservation_equipment_ids_[value='#{item.id}']").set(true)
  if quantity
    fill_in "reservation_quantity_#{item.id}", with: quantity
  end
end

def have_item(item)
  have_selector 'ul.equipment-show-list>li', text: item.name
end

def expect_conflicts(page)
  expect(page).to have_title('New Reservation')
  expect(page).to have_selector '.alert.alert-danger>h4'
end

def have_conflict(name, out_string, in_string)
  # TODO: Refactor times to not be strings
  have_selector '.alert.alert-danger>ul>li', text: "#{name} is already reserved from #{out_string} to #{in_string}"
end

describe 'Conflict checking', type: :request do
  let(:user) { FactoryGirl.create(:user) }
  let(:permission) { FactoryGirl.create(:permission) }
  let(:mic1) { FactoryGirl.create(:equipment) }
  let(:mic2) { FactoryGirl.create(:equipment) }
  let(:mic3) { FactoryGirl.create(:equipment) }

  before do
    mic1.quantity = 3
    mic1.save
    mic2.quantity = 1
    mic2.save
    mic3.quantity = 1
    mic3.save
    permission.users = [user]
    permission.equipment = [mic1, mic2, mic3]
    permission.save

    sign_in(user)
    visit new_reservation_path
  end

  describe 'checking out some equipment' do
    before do
      fill_in 'reservation_project', with: 'Integration testing'
      fill_in 'reservation_out_time', with: '05/20/2015 8:44 PM'
      fill_in 'reservation_in_time', with: '05/21/2015 8:44 PM'
      check_item(mic1)
      check_item(mic2)
      click_on 'Create Reservation'
    end

    it 'should not have any conflicts' do
      expect(page).to have_title 'Integration testing'
      expect(page).to have_item mic1
      expect(page).to have_item mic2
    end

    describe 'then checking out conflicting equipment' do
      before do
        visit new_reservation_path

        fill_in 'reservation_project', with: 'Conflict testing'
        fill_in 'reservation_out_time', with: '05/21/2015 2:44 PM'
        fill_in 'reservation_in_time', with: '05/21/2015 8:44 PM'
        check_item(mic2)
        click_on 'Create Reservation'
      end

      it 'should show that there is a conflict' do
        expect_conflicts(page)
        expect(page).to have_conflict(mic2.name, 'Wed, 05/20/15, 08:44 PM', 'Thu, 05/21/15, 08:44 PM')
      end
    end

    describe 'then checking out equipment with enough to go around' do
      before do
        visit new_reservation_path

        fill_in 'reservation_project', with: 'Lots of mics'
        fill_in 'reservation_out_time', with: '05/21/2015 2:44 PM'
        fill_in 'reservation_in_time', with: '05/21/2015 8:44 PM'
        check_item(mic1)
        click_on 'Create Reservation'
      end

      it 'should not have any conflicts' do
        expect(page).to have_title 'Lots of mics'
        expect(page).to have_item mic1
      end
    end

    describe 'then checking out more equipment than is available' do
      before do
        visit new_reservation_path

        fill_in 'reservation_project', with: 'Lots of mics'
        fill_in 'reservation_out_time', with: '05/21/2015 2:44 PM'
        fill_in 'reservation_in_time', with: '05/21/2015 8:44 PM'
        check_item(mic1, 3)
        click_on 'Create Reservation'
      end

      it 'should show a conflict' do
        expect_conflicts(page)
        expect(page).to have_conflict(mic1.name, 'Wed, 05/20/15, 08:44 PM', 'Thu, 05/21/15, 08:44 PM')
      end
    end

    describe 'then checking out different equipment' do
      before do
        visit new_reservation_path

        fill_in 'reservation_project', with: 'Different Equipment'
        fill_in 'reservation_out_time', with: '05/21/2015 2:44 PM'
        fill_in 'reservation_in_time', with: '05/21/2015 8:44 PM'
        check_item(mic3)
        click_on 'Create Reservation'
      end

      it 'should not have any conflicts' do
        expect(page).to have_title 'Different Equipment'
        expect(page).to have_item mic3
      end
    end

    describe 'then checking out equipment at a different time' do
      before do
        visit new_reservation_path

        fill_in 'reservation_project', with: 'Future project'
        fill_in 'reservation_out_time', with: '05/30/2015 8:44 PM'
        fill_in 'reservation_in_time', with: '05/31/2015 8:44 PM'
        check_item(mic1)
        check_item(mic2)
        click_on 'Create Reservation'
      end

      it 'should not have any conflicts' do
        expect(page).to have_title 'Future project'
        expect(page).to have_item mic1
        expect(page).to have_item mic2
      end
    end
  end
end

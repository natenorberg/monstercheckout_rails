require 'rails_helper'

def check_equipment(equipment)
  find(:css, "#reservation_equipment_ids_[value='#{equipment.id}']").set(true)
end

describe 'Conflict checking', type: :request do
  let(:user) { FactoryGirl.create(:user) }
  let(:permission) { FactoryGirl.create(:permission) }
  let(:mic1) { FactoryGirl.create(:equipment) }
  let(:mic2) { FactoryGirl.create(:equipment) }

  before do
    permission.users = [user]
    permission.equipment = [mic1, mic2]
    permission.save

    sign_in(user)
    visit new_reservation_path
  end

  it 'should have equipment in the list' do
    page.assert_selector 'ul.equipment-list>li', count: 2
  end

  it 'should let you create the first reservation no problem' do
    fill_in 'reservation_project', with: 'Integration testing'
    fill_in 'reservation_out_time', with: '05/20/2015 8:44 PM'
    fill_in 'reservation_in_time', with: '05/21/2015 8:44 PM'
    check_equipment(mic1)
    check_equipment(mic2)
    click_on 'Create Reservation'

    expect(page).to have_title 'Integration testing'
    expect(page).to have_selector 'ul.equipment-show-list>li', text: mic1.name
    expect(page).to have_selector 'ul.equipment-show-list>li', text: mic2.name
  end
end

require 'spec_helper'

class LensSpec < Struct.new(:registered_at, :mfr, :mount, :name, :mm, :f, :close_up, :note)

  def close_up_state
    close_up ? 'available' : 'unavailable'
  end

  def registered_datetime
    registered_at.strftime("%Y-%m-%d %H:%M")
  end

  def registered_year;  registered_at.year;  end
  def registered_month; registered_at.month; end
  def registered_day;   registered_at.day;   end
  def registered_hour;  "%02d" % registered_at.hour;  end
  def registered_min;   "%02d" % registered_at.min;   end
end

feature 'confirm add lens' do
  background do
    visit 'lenses/new'
    select lens.registered_year,  from: 'lens[registered_at(1i)]'
    select lens.registered_month, from: 'lens[registered_at(2i)]'
    select lens.registered_day,   from: 'lens[registered_at(3i)]'
    select lens.registered_hour,  from: 'lens[registered_at(4i)]'
    select lens.registered_min,   from: 'lens[registered_at(5i)]'
    select lens.mfr.name, from: 'lens[mfr_id]'
    choose lens.mount.name
    fill_in 'lens[name]', with: lens.name
    fill_in 'lens[mm]', with: lens.mm
    fill_in 'lens[f]', with: lens.f
    fill_in 'lens[note]', with: lens.note
    click_button 'Confirm'
  end

  let(:lens) do
    LensSpec.new(
      Time.current,
      MFR.find_by(name: 'Leica'),
      Mount.find_by(name: 'Leica M'),
      'Summilux', 35, 1.4, false, '1st'
    )
  end

  scenario 'see inputted content' do
    expect(page).to have_content(/Registered at\s+#{lens.registered_datetime}/)
    expect(page).to have_content(/MFR\s+#{lens.mfr.name}/)
    expect(page).to have_content(/Mount\s+#{lens.mount.name}/)
    expect(page).to have_content(/Name\s+#{lens.name}/)
    expect(page).to have_content(/mm\s+#{lens.mm}/)
    expect(page).to have_content(/f\s+#{lens.f}/)
    expect(page).to have_content(/Close up\s+#{lens.close_up_state}/)
    expect(page).to have_content(/Note\s+#{lens.note}/)
  end
end
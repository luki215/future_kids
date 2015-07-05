require 'requests/acceptance_helper'

feature 'Kid Mentor planning', js: true do
  let(:kid) {
    kid = create(:kid)

    kid.schedules.create(day: 1, hour: 16, minute: 0)
    kid.schedules.create(day: 1, hour: 16, minute: 30)
    kid.schedules.create(day: 1, hour: 17, minute: 0)
    kid.schedules.create(day: 1, hour: 17, minute: 30)
    kid.schedules.create(day: 1, hour: 18, minute: 0)
    kid.schedules.create(day: 1, hour: 18, minute: 30)

    kid.schedules.create(day: 2, hour: 15, minute: 0)
    kid.schedules.create(day: 2, hour: 15, minute: 30)
    kid.schedules.create(day: 2, hour: 16, minute: 0)
    kid.schedules.create(day: 2, hour: 16, minute: 30)
    kid.schedules.create(day: 2, hour: 17, minute: 0)
    kid.schedules.create(day: 2, hour: 17, minute: 30)
    kid
  }
  let!(:admin) { create(:admin) }
  let!(:mentor_frederik) {
    # Frederik receives ects and has no kid assigned
    mentor = create(:mentor, ects: true, prename: 'Frederik', name: 'Haller', sex: 'm')
    mentor.schedules.create(day: 1, hour: 14, minute: 0)
    mentor.schedules.create(day: 1, hour: 14, minute: 30)
    mentor.schedules.create(day: 1, hour: 15, minute: 0)
    mentor.schedules.create(day: 1, hour: 15, minute: 30)
    mentor.schedules.create(day: 1, hour: 16, minute: 0)
    mentor.schedules.create(day: 1, hour: 16, minute: 30)
    mentor.schedules.create(day: 2, hour: 14, minute: 0)
    mentor.schedules.create(day: 2, hour: 14, minute: 30)
    mentor.schedules.create(day: 2, hour: 15, minute: 0)
    mentor.schedules.create(day: 2, hour: 15, minute: 30)
    mentor.schedules.create(day: 2, hour: 16, minute: 0)
    mentor.schedules.create(day: 2, hour: 16, minute: 30)
    mentor
  }
  let!(:mentor_melanie) {
    # melanie receives ects, she has already one kid assigned
    mentor = create(:mentor, ects: true, prename: 'Melanie', name:'Rohner', sex: 'f')
    mentor.schedules.create(day: 3, hour: 14, minute: 0)
    mentor.schedules.create(day: 3, hour: 14, minute: 30)
    mentor.schedules.create(day: 3, hour: 15, minute: 0)
    mentor.schedules.create(day: 3, hour: 15, minute: 30)
    mentor.schedules.create(day: 3, hour: 16, minute: 0)
    mentor.schedules.create(day: 3, hour: 16, minute: 30)
    mentor.schedules.create(day: 5, hour: 14, minute: 0)
    mentor.schedules.create(day: 5, hour: 14, minute: 30)
    mentor.schedules.create(day: 5, hour: 15, minute: 0)
    mentor.schedules.create(day: 5, hour: 15, minute: 30)
    mentor.schedules.create(day: 5, hour: 16, minute: 0)
    mentor.schedules.create(day: 5, hour: 16, minute: 30)
    mentor.kids.push create(:kid)
    mentor
  }
  let!(:mentor_max) {
    # max does not receive ects and has a secondary kid assigned
    mentor =create(:mentor, ects: false, prename: 'Max', name: 'Steiner', sex: 'm')
    mentor.schedules.create(day: 1, hour: 17, minute: 0)
    mentor.schedules.create(day: 1, hour: 17, minute: 30)
    mentor.schedules.create(day: 1, hour: 18, minute: 0)
    mentor.schedules.create(day: 1, hour: 18, minute: 30)
    mentor.schedules.create(day: 1, hour: 19, minute: 0)
    mentor.schedules.create(day: 2, hour: 14, minute: 30)
    mentor.schedules.create(day: 2, hour: 15, minute: 0)
    mentor.schedules.create(day: 2, hour: 15, minute: 30)
    mentor.schedules.create(day: 2, hour: 16, minute: 0)
    mentor.schedules.create(day: 2, hour: 16, minute: 30)
    mentor.schedules.create(day: 2, hour: 17, minute: 0)
    mentor.schedules.create(day: 2, hour: 17, minute: 30)
    mentor.secondary_kids.push create(:kid)
    mentor
  }

  let!(:mentor_sarah) {

    # sarah does not receive ects and already has two kids assigned
    mentor =create(:mentor, ects: false, prename: 'Sarah', name: 'Koller', sex: 'f')
    mentor.schedules.create(day: 1, hour: 17, minute: 0)
    mentor.schedules.create(day: 1, hour: 17, minute: 30)
    mentor.schedules.create(day: 1, hour: 18, minute: 0)
    mentor.schedules.create(day: 1, hour: 18, minute: 30)
    mentor.schedules.create(day: 1, hour: 19, minute: 0)
    mentor.schedules.create(day: 2, hour: 14, minute: 30)
    mentor.schedules.create(day: 2, hour: 15, minute: 0)
    mentor.schedules.create(day: 2, hour: 15, minute: 30)
    mentor.schedules.create(day: 2, hour: 16, minute: 0)
    mentor.schedules.create(day: 2, hour: 16, minute: 30)
    mentor.schedules.create(day: 2, hour: 17, minute: 0)
    mentor.schedules.create(day: 2, hour: 17, minute: 30)
    mentor.kids.push create(:kid)
    mentor.secondary_kids.push create(:kid)

    mentor
  }

  background do
    expect(User.first.valid_password?(admin.password)).to eq(true)
    log_in(admin)
    visit show_kid_mentors_schedules_kid_path(id: kid.id)
  end

  describe 'kid-mentor-schedules component' do
    scenario 'has a filter compoment' do
      within('.kid-mentor-schedules') do
        expect(page).to have_selector('.filters')
      end
    end


    describe 'filter' do
      describe 'number-of-kids-filter' do
        scenario 'initially is set to show only mentors with 0 or 1 kid' do
          find(:css, '.filters [name="number-of-kids"]').value.should == '0-1'
        end
        scenario 'select only mentors with 0 or 1 kid assigned' do
          within('.filters [name="number-of-kids"]') do
            find('option[value="0-1"]').click
          end

          within('.kid-mentor-schedules') do
            expect(page).to have_content 'Haller Frederik'
            expect(page).to have_content 'Steiner Max'
            expect(page).to have_content 'Rohner Melanie'
            expect(page).not_to have_content 'Koller Sarah'
          end
        end
        scenario 'select only mentors with 1 kid assigned' do
          within('.filters [name="number-of-kids"]') do
            find('option[value="1"]').click
          end
          within('.kid-mentor-schedules') do
            expect(page).not_to have_content 'Haller Frederik'
            expect(page).to have_content 'Steiner Max'
            expect(page).to have_content 'Rohner Melanie'
            expect(page).not_to have_content 'Koller Sarah'
          end
        end
        scenario 'select only mentors with 2 kid assigned' do
          within('.filters [name="number-of-kids"]') do
            find('option[value="2"]').click
          end
          within('.kid-mentor-schedules') do
            expect(page).not_to have_content 'Haller Frederik'
            expect(page).not_to have_content 'Steiner Max'
            expect(page).not_to have_content 'Rohner Melanie'
            expect(page).to have_content 'Koller Sarah'
          end
        end
        scenario 'show all mentors, regardless of the number of kids assigned' do
          within('.filters [name="number-of-kids"]') do
            find('option[value="all"]').click
          end
          within('.kid-mentor-schedules') do
            expect(page).to have_content 'Haller Frederik'
            expect(page).to have_content 'Steiner Max'
            expect(page).to have_content 'Rohner Melanie'
            expect(page).to have_content 'Koller Sarah'
          end
        end
      end
      describe 'ects-filter' do
        background do
          within('.filters [name="number-of-kids"]') do
            find('option[value="all"]').click
          end
        end
        scenario 'select ects' do
          within('.filters [name="ects"]') do
            find('option[value="true"]').click
          end
          within('.kid-mentor-schedules') do
            expect(page).to have_content 'Haller Frederik'
            expect(page).to have_content 'Rohner Melanie'
            expect(page).to_not have_content 'Steiner Max'
            expect(page).to_not have_content 'Koller Sarah'
          end
        end
        scenario 'select no ects' do
          within('.filters [name="ects"]') do
            find('option[value="false"]').click
          end
          within('.kid-mentor-schedules') do
            expect(page).to_not have_content 'Haller Frederik'
            expect(page).to_not have_content 'Rohner Melanie'
            expect(page).to have_content 'Steiner Max'
            expect(page).to have_content 'Koller Sarah'
          end
        end

      end

      describe 'sex-filter' do
        background do
          within('.filters [name="number-of-kids"]') do
            find('option[value="all"]').click
          end
        end

        scenario 'select only male or only female mentors' do
          within('.filters [name="sex"]') do
            find('option[value="m"]').click
          end
          within('.kid-mentor-schedules') do
            expect(page).to have_content 'Haller Frederik'
            expect(page).to_not have_content 'Rohner Melanie'
            expect(page).to have_content 'Steiner Max'
            expect(page).to_not have_content 'Koller Sarah'
          end
          within('.filters [name="sex"]') do
            find('option[value="f"]').click
          end
          within('.kid-mentor-schedules') do
            expect(page).to_not have_content 'Haller Frederik'
            expect(page).to have_content 'Rohner Melanie'
            expect(page).to_not have_content 'Steiner Max'
            expect(page).to have_content 'Koller Sarah'
          end
        end

      end

    end



    describe 'timetable' do
      it 'shows all weekdays' do
        within('.timetable') do
          expect(page).to have_content 'Montag'
          expect(page).to have_content 'Dienstag'
          expect(page).to have_content 'Mittwoch'
          expect(page).to have_content 'Donnerstag'
          expect(page).to have_content 'Freitag'
        end
      end
      it 'shows times from 13:00 to 19:00 with 30min intervals' do
        within('.timetable') do
          expect(page).to_not have_content '12:30'
          expect(page).to have_content '13:00'
          expect(page).to have_content '13:30'
          expect(page).to have_content '14:00'
          expect(page).to have_content '18:00'
          expect(page).to have_content '18:30'
          expect(page).to have_content '19:00'
          expect(page).to_not have_content '19:30'
        end
      end
      it 'shows a column box per mentor per time if active' do
        within('.timetable') do
          expect(page).to have_selector('.cell-mentor', count: 12*3)
        end
      end
      scenario 'select no ects' do
        within('.filters [name="ects"]') do
          find('option[value="false"]').click
        end
        within('.timetable') do
          expect(page).to have_selector('.cell-mentor', count: 12)
        end
      end

      scenario 'select one entry to store the date' do
        within('.timetable') do
          first('.kid-available .cell-mentor .btn-set-date').click

          page.driver.browser.switch_to.alert.accept
        end
        within('.kid_meeting_day') do
          expect(page).to have_content 'Dienstag'
        end
        within('.kid_meeting_start_at') do
          expect(page).to have_content '15:00'
        end
        within('.kid_meeting_start_at') do
          expect(page).to have_content '15:00'
        end
        within('.kid_mentor') do
          expect(page).to have_content 'Haller Frederik'
        end
      end
    end
  end
end

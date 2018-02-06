module Pages
  class Availability < SitePrism::Page
    set_url '/locations/{location_id}/slots'

    elements :rooms, '.t-room'
    elements :slots, '.t-slot'
    elements :appointments, '.t-appointment'

    element :success, '.t-success'
    element :day, '.fc-agendaDay-button'

    element :ok, '.ok'

    def wait_for_calendar_events
      find('.t-calendar-rendered', visible: false)
    end

    def accept_confirmation
      wait_until_ok_visible
      ok.click
    end

    def click_slot(time, resource_name = 'Room no.') # rubocop:disable Metrics/MethodLength
      x, y = page.driver.evaluate_script <<-JS
        function() {
          var $calendar = $('.t-calendar');
          var $header = $calendar.find(".fc-resource-cell:contains('#{resource_name}')");
          if ($header.length > 0) {
            var $row = $calendar.find('[data-time="#{time}:00"]');
            return [$header.offset().left + 5, $row.offset().top + 5];
          }
        }();
      JS

      page.driver.click(x, y)
    end
  end
end

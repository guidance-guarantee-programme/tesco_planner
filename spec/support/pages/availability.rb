module Pages
  class Availability < SitePrism::Page
    set_url '/locations/{location_id}/slots'

    elements :rooms, '.t-room'
    elements :slots, '.t-slot'

    element :success, '.t-success'
    element :day, '.fc-agendaDay-button'

    def dismiss_confirmations
      page.evaluate_script <<-JS
        window.confirm = function() {
          return true;
        };
      JS
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

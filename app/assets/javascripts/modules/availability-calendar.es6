'use strict';

/* global moment */
{
  class AvailabilityCalendar {
    start(el) {
      this.$el = el;

      $(this.$el).fullCalendar({
        header: {
          right: 'agendaDay agendaWeek prev,next'
        },
        resourceLabelText: 'Rooms',
        groupByDateAndResource: true,
        nowIndicator: true,
        allDaySlot: false,
        buttonText: {
          today: 'Jump to today'
        },
        slotLabelInterval: { 'minutes': 60 },
        displayEventTime: false,
        columnFormat: 'ddd D/M',
        height: 'auto',
        maxTime: '18:00:00',
        minTime: '09:00:00',
        weekends: false,
        defaultView: 'agendaWeek',
        slotDuration: '00:10:00',
        showNonCurrentDates: false,
        defaultDate: moment(el.data('default-date')),
        firstDay: 1,
        resources: el.data('rooms-uri'),
        eventSources: [
          {
            url: el.data('slots-uri'),
            cache: true,
            rendering: 'background',
            eventType: 'slot'
          }
        ],
        dayClick: (date, jsEvent) => {
          jsEvent.preventDefault()

          if (jsEvent.target.classList.contains('js-slot')) {
            if (confirm('Are you sure you want to delete this slot?')) {
              const id = jsEvent.target.id

              $.ajax({
                type: 'DELETE',
                url: `${this.$el.data('slots-uri')}/${id}`,
                headers: { 'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content') },
                success: () => {
                  $(this.$el).fullCalendar('refetchEvents')

                  $('.alert')
                    .hide()
                    .filter('.alert-success')
                    .show()
                    .delay(3000)
                    .fadeOut('slow');
                }
              })
            }
          }
        },
        eventRender: (event, element) => {
          $(element).attr('id', event.id).addClass('t-slot js-slot')
        },
        resourceRender: (resource, labelTds) => {
          labelTds.addClass('t-room')
        },
        schedulerLicenseKey: 'GPL-My-Project-Is-Open-Source'
      });
    }
  }

  window.GOVUKAdmin.Modules.AvailabilityCalendar = AvailabilityCalendar;
}

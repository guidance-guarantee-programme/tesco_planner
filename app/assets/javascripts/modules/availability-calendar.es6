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
        resources: this.$el.data('rooms-uri'),
        resourceRender: (resource, labelTds) => {
          labelTds.addClass('t-room')
        },
        schedulerLicenseKey: 'GPL-My-Project-Is-Open-Source'
      });
    }
  }

  window.GOVUKAdmin.Modules.AvailabilityCalendar = AvailabilityCalendar;
}

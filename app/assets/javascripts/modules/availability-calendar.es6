'use strict';

/* global moment, alertify */
{
  class AvailabilityCalendar {
    start(el) {
      this.$el = el;
      this.$slotsUri = this.$el.data('slots-uri')
      this.$modal = this.$el.find('.js-availability-modal')

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
        slotLabelInterval: { 'minutes': 15 },
        displayEventTime: false,
        columnFormat: 'ddd D/M',
        height: 'parent',
        maxTime: '20:00:00',
        minTime: '09:00:00',
        weekends: false,
        defaultView: 'agendaWeek',
        slotDuration: '00:05:00',
        showNonCurrentDates: false,
        defaultDate: moment(el.data('default-date')),
        firstDay: 1,
        resources: '/rooms.json',
        timezone: 'local',
        eventSources: [
          {
            url: this.$slotsUri,
            cache: true,
            rendering: 'background',
            eventType: 'slot'
          },
          {
            url: '/appointments.json',
            eventType: 'appointment'
          }
        ],
        dayClick: (date, jsEvent, _, resourceObject) => {
          jsEvent.preventDefault()

          if (jsEvent.target.classList.contains('js-slot')) {
            this.deleteSlot(jsEvent)
          } else {
            this.createSlot(date, resourceObject)
          }
        },
        eventRender: (event, element) => {
          if (event.source.eventType === 'slot') {
            $(element).addClass('t-slot js-slot')
          } else {
            $(element).addClass('t-appointment js-appointment')

            if(event.cancelled) {
              $(element).addClass('fc-event--cancelled')
            }
          }

          $(element).attr('id', event.id)
        },
        eventAfterAllRender: () => {
          // mark the calendar as reloaded
          let $rendered = $("<div class='t-calendar-rendered' style='display:hidden;'></div>")
          $('body').append($rendered);
        },
        resourceRender: (resource, labelTds) => {
          labelTds.addClass('t-room')
        },
        loading: (isLoading) => {
          if (isLoading) {
            // mark the calendar as reloading
            $('.t-calendar-rendered').remove()
          }

          this.insertLoadingView();

          if (!isLoading && this.$loadingSpinner) {
            clearTimeout(this.loadingTimeout);
            return this.$loadingSpinner.addClass('hide');
          }

          this.loadingTimeout = setTimeout(() => {
            if (isLoading && this.$loadingSpinner) {
              this.$loadingSpinner.removeClass('hide');
            }
          }, 200);
        },
        schedulerLicenseKey: 'GPL-My-Project-Is-Open-Source'
      });
    }

    deleteSlot(jsEvent) {
      alertify
        .theme('bootstrap')
        .okBtn('OK')
        .confirm('Are you sure you want to delete this slot?', (e) => {
          e.preventDefault()

          const id = jsEvent.target.id

          $.ajax({
            type: 'DELETE',
            url: `${this.$slotsUri}/${id}`,
            headers: { 'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content') },
            success: () => {
              $(this.$el).fullCalendar('refetchEvents')

              this.showSuccess()
            },
            error: () => {
              alertify.theme('bootstrap').alert('You cannot delete this slot.')
            }
          })
        })
    }

    showSpinner() {
      this.$loadingSpinner.removeClass('hide');
    }

    hideSpinner() {
      this.$loadingSpinner.addClass('hide');
    }

    insertLoadingView() {
      if (this.$loadingSpinner) {
        return;
      }

      this.$loadingSpinner = $(`
        <div class="calendar-loading hide">
          <div class="loading-spinner loading-spinner--large">
            <div class="loading-spinner__bounce loading-spinner__bounce--1"></div>
            <div class="loading-spinner__bounce loading-spinner__bounce--2"></div>
            <div class="loading-spinner__bounce"></div>
          </div>
        </div>`);

      this.$loadingSpinner.appendTo($('.fc-view-container'));
    }

    showSuccess() {
      $('.alert')
        .hide()
        .filter('.alert-success')
        .show()
        .delay(3000)
        .fadeOut('slow');
    }

    createSlot(date, resourceObject) {
      $.post({
        url: this.$slotsUri,
        data: { start_at: date.utc().format(), room_id: resourceObject.id },
        headers: { 'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content') },
        success: () => {
          $(this.$el).fullCalendar('refetchEvents')
        }
      })
    }
  }

  window.GOVUKAdmin.Modules.AvailabilityCalendar = AvailabilityCalendar;
}

'use strict';

/* global moment */
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
        timezone: 'local',
        eventSources: [
          {
            url: this.$slotsUri,
            cache: true,
            rendering: 'background',
            eventType: 'slot'
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
          $(element).attr('id', event.id).addClass('t-slot js-slot')
        },
        resourceRender: (resource, labelTds) => {
          labelTds.addClass('t-room')
        },
        loading: (isLoading) => {
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
      if (confirm('Are you sure you want to delete this slot?')) {
        this.showSpinner()

        const id = jsEvent.target.id

        $.ajax({
          type: 'DELETE',
          url: `${this.$slotsUri}/${id}`,
          headers: { 'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content') },
          success: () => {
            $(this.$el).fullCalendar('refetchEvents')

            this.showSuccess()
          },
          complete: () => {
            this.hideSpinner()
          }
        })
      }
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
      this.showSpinner()

      $.post({
        url: this.$slotsUri,
        data: { start_at: date.utc().format(), room_id: resourceObject.id },
        headers: { 'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content') },
        success: () => {
          $(this.$el).fullCalendar('refetchEvents')
        },
        complete: () => {
          this.hideSpinner()
        }
      })
    }
  }

  window.GOVUKAdmin.Modules.AvailabilityCalendar = AvailabilityCalendar;
}

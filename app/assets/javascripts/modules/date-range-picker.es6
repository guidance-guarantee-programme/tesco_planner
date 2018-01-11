/* global moment */
'use strict';
{

  class DateRangePicker {
    start(el) {
      this.$el = $(el);
      this.init();
      this.bindEvents();
    }

    init() {
      this.$el.daterangepicker({
        timePicker24Hour: true,
        ranges: {
          'Today': [moment(), moment()],
          'Tomorrow': [moment().add(1, 'days'), moment().add(1, 'days')],
          'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
          'Last 7 Days': [moment().subtract(6, 'days'), moment()],
          'Last 30 Days': [moment().subtract(29, 'days'), moment()],
          'This Month': [moment().startOf('month'), moment().endOf('month')],
          'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]
        },
        locale: {
          format: 'DD/MM/YYYY',
          cancelLabel: 'Clear'
        },
        autoUpdateInput: false
      });
    }

    bindEvents() {
      this.$el.on('apply.daterangepicker', (ev, picker) => {
        this.$el.val(`${picker.startDate.format('DD/MM/YYYY')} - ${picker.endDate.format('DD/MM/YYYY')}`);
      });
      this.$el.on('cancel.daterangepicker', () => {
        this.$el.val('');
      });
    }
  }

  window.GOVUKAdmin.Modules.DateRangePicker = DateRangePicker;
}

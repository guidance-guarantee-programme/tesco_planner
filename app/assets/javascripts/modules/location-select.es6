'use strict';

{
  class LocationSelect {
    start(el) {
      this.$el = el;

      $(this.$el).select2({theme: 'bootstrap', dropDownAutoWidth: true});
    }
  }

  window.GOVUKAdmin.Modules.LocationSelect = LocationSelect;
}

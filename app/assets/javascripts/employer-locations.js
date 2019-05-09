$(function() {
  locations = $('.js-locations').html();

  $('.js-employers').change(function() {
    employer = $('.js-employers :selected').text();
    options = $(locations).filter('optgroup[label="' + employer + '"]');

    if(options.length) {
      $('.js-locations').html(options.prepend('<option value="">All Locations</option>').html());
    } else {
      $('.js-locations').html(locations);
    }
  });
});

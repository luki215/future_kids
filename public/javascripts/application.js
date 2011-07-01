$(function () {
  register_subnav_expand();
  register_datepickers();
});

// navigation items with further nesting are handled specially:
// they are not displayed, but clicking on the elements above the sub-sub list
function register_subnav_expand() {
  $('ul > li > ul').parents('li').hide();
  $('ul > li > ul').each(function() {
    $(this).parent().prev().click(function() {
		  $(this).next().toggle('fast');
		  return false;
    });
  });
}

// registers jquery ui datepickers on given fields when applicable
function register_datepickers() {

  var settings = {
    isoTime: true,
    minTime: {hour: 13, minute: 0},
    maxTime: {hour: 19, minute: 0},
    timeInterval: 30
  };

  $('#journal_held_at').calendricalDate();

  $('#journal_start_at, #journal_end_at').calendricalTimeRange(settings)

  $('#review_held_at').calendricalDate();

  $('#kid_entered_at').calendricalDate();
  $('#kid_meeting_start_at').calendricalTime(settings);

  $('#mentor_entry_date').calendricalDate();

}


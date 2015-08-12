// Disable searching and ordering by default for datatable
$.extend( $.fn.dataTable.defaults, {
    searching: false,
    ordering:  false
});

// add div for facebook
$(function() {

  /**
   * Fix header
   */
  var header = document.getElementById('site-head'),
  headerHeadRoom =  new Headroom(header, {
    offset: 205,
    tolerance: 5,
    classes: {
      initial: "animated",
      pinned: "slideDown",
      unpinned: "slideUp"
    }
  });

  headerHeadRoom.init();

  $('#site-head').hover(function(){
    if($(this).hasClass('headroom--not-top'))
    {
      $(this).addClass('reveal');
    } else {
     $(this).removeClass('reveal');
    }
  }, function(){
    setTimeout( function () {
      $('#site-head').removeClass('reveal');
      }
    , 600);
  });


  /**
   * Navigation
   */
  if(d4p.mapIsChunked())
  {
    //$('#side-navigation').addClass('affix').find('li').removeClass('active');
    $('body').scrollspy(
      { target: '#side-navigation' }
    );
    $('#side-navigation').on('activate.bs.scrollspy', function (e) {
     console.log(e);
    });

  } else if(!d4p.root) {
    navigation.nav.id = '#side-navigation';
    navigation.cs.expand = 'ic fa fa-expand ';
    navigation.cs.collapse = 'ic fa fa-compress ';
    navigation.cs.close =  'ic fa fa-close ';
    navigation.cs.plus =  'ic fa fa-plus';
    navigation.cs.minus =  'ic fa fa-minus';
    navigation.init();
  }
  //$('body').scrollspy({ target: '#side-navigation' })

  /**
   * popover
   */
 // $('abbr').popover({delay: { "show": 500, "hide": 100 }});
 // $('html').click(function() {
 //   $('.popover').popover('hide');
//  });


  /**
   * Serach index
   */
  var idx = new searchIdx(),
  closeBtn = $('<button />').attr('id', 'searchClose').attr('type', 'button').attr('class', 'float_right').append($('<span />').attr('class', 'fa fa-close')).append($('<span />').html(d4p.l.close).attr('class', 'hidden')).hide();

  $('#search-text').after(closeBtn);

  $( "#search" ).submit(function( event ) {
    event.preventDefault();
  });

  if(d4p.mapIsChunked())
  {
    $('#search-text').keyup(function( event ) {
      $('#page').unhighlight();
      $('#page').highlight($(this).val());
      $('#searchClose').show();
    });

    closeBtn.on('click', function(){
      $('.highlight').remove();
      $('#search-text').val('');
      $(this).hide();
    });

  } else {
    idx.getData();
    idx.searchResultPlaceholder();

    closeBtn.on('click', function(){
      $('#page').children().show();
      $('#search_result').hide();
      $('#search-text').val('');
      $(this).hide();
    });

    $('#search-text').keyup(function( event ) {
      if($(this).val().length > d4p.search.minlength)
      {
        idx.search($(this).val());
        idx.output();
        $('#page').children().hide();
        $('#search_result').show();
        $('#searchClose').show();
      }
    });
}

// var myElement = document.getElementById('touch');
//
// // create a simple instance
// // by default, it only adds horizontal recognizers
// var mc = new Hammer(myElement);
//
// // let the pan gesture support all directions.
// // this will block the vertical scrolling on a touch-device while on the element
// mc.get('pan').set({ direction: Hammer.DIRECTION_ALL });
//
// // listen to events...
// mc.on("panleft panright panup pandown tap press", function(ev) {
//      if(ev.type == 'panleft' && d4p.previousTopicHref !== null && d4p.previousTopicHref !== '')
//        {
//          document.location = d4p.getDocumentationRoot() + d4p.previousTopicHref;
//       }
//       if(ev.type == 'panright' && d4p.nextTopicHref !== null && d4p.nextTopicHref !== '')
//        {
//          document.location = d4p.getDocumentationRoot() + d4p.nextTopicHref;
//       }
//});

});

$(function() {

  $('#LinkTwitter')
    .attr('href', 'https://twitter.com/intent/tweet?text='+$('title').html()+'&url='+window.location);

  $('#LinkFacebook')
    .attr('href', 'https://twitter.com/intent/tweet?text='+$('title').html()+'&url='+window.location);

});

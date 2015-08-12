var group = {

  el: 'employee_group',

  toolBarContainer: 'toolbar',
  
  lang: $('html').attr('lang'),
  
  domain: '.uottawa.ca',
  
  expire: 3650,
  
  cookie: 'eg',
  
  previous: false,
  
  init: function(){   
    if(document.getElementById(this.el) != null)
    {
      this.replace();
      this.addToolbar();
      this.buttonsClick();
      this.showSelection();
    } 
  },
  
  replace:function() {
    $(".group-link").replaceWith(function() {
          return $("<div />").addClass($(this).attr('class')).attr('data-href', $(this).attr('href')).html($(this).html());
      });
  },
  
  addToolbar: function() {
    var self = this;
    var submit = $("<button />").attr('id', 'confirmBtn').attr('class', 'btn').attr('disabled', 'disabled').html(this.lang=='en-ca'?'Confirm':'Confirmer').click(function(e){
    var page = getParameterByName('hash');
    
      e.preventDefault();
      $.cookie(self.cookie, $(this).attr('data-value'));
    
      if($(this).attr('data-value') !== '') {
          window.parent.location.replace($(this).attr('data-value')+'/'+page);
        }
      });
      span = $('<span/>').attr('id', 'confirmSrOnly').attr('class', 'sr-only');
      submit.append(span);
      
     toolBar = $("<div />").addClass("toolBar").attr('id', 'confirm-dialog');  
     toolBar.append(submit);
     toolBar.prepend($('<div/>').attr('id', 'dialog'));
     
     submit.after("&nbsp;");  
         
      $('#'+this.toolBarContainer).prepend(toolBar);

  },
  
  prepareConfirmation: function (obj) {
    var choice = obj.find('h2').html(),
    preffix = ''    ;
    if(this.previous)
    {
      preffix = this.lang == 'fr-ca' ? ' Votre choix précédent était: ' : ' Your previous choice was: ';
    } else {
      preffix = this.lang == 'fr-ca' ? ' Votre choix est: ' : ' Your choice is: ';
    }
    $('#confirmBtn').attr('data-name', obj.attr('id')).attr('data-value', obj.attr('data-href')).removeAttr('disabled').addClass('btn-primary');
    $('#confirmSrOnly').html(choice);
    $('#dialog').html(preffix + choice);
  },
  
  showSelection: function() {
    var group = $.cookie(this.cookie);
    if(group != undefined)
    {
      this.previous = true;
      $('h1').html(this.lang == 'fr-ca' ? 'Veuillez confirmer votre groupe d\'employé' : 'Please confirm your employee group')
      var obj = $(".group-link[data-href='" + group + "']");
      this.prepareConfirmation(obj);  
      this.select(obj);
    }
  },
  
  buttonsClick: function () {
  
    var self = this;
 
    $(".group-link").click(function(e){
      e.preventDefault();
      self.previous = false;
      self.prepareConfirmation($(this));  
      self.select($(this));
    });
  },
  
  select: function(obj) {
    $(".group-link").removeClass("selected").addClass("not-selected");
    obj.removeClass("not-selected").addClass('selected');     
    $('#confirm-dialog').addClass('enabled').attr("tabindex",-1).focus();
  }

}

$(function() {
  group.initialAudience = false;
  group.cancelBtn = false;
  group.init();
});



/* ALERT CLASS DEFINITION
  * ====================== */
jQuery(function(){

  var dismiss = '[data-dismiss="alert"]'
    , Alert = function (el) {
        $(el).on('click', dismiss, this.close)
      }

  Alert.prototype.close = function (e) {
    var $this = $(this)
      , selector = $this.attr('data-target')
      , $parent

    if (!selector) {
      selector = $this.attr('href')
      selector = selector && selector.replace(/.*(?=#[^\s]*$)/, '') //strip for ie7
    }

    $parent = $(selector)

    e && e.preventDefault()

    $parent.length || ($parent = $this.hasClass('alert') ? $this : $this.parent())

    $parent.trigger(e = $.Event('close'))

    if (e.isDefaultPrevented()) return

    $parent.removeClass('in')

    function removeElement() {
      $parent
        .trigger('closed')
        .remove()
    }

    $.support.transition && $parent.hasClass('fade') ?
      $parent.on($.support.transition.end, removeElement) :
      removeElement()
  }
///////////////////////////////Code Löscht Formulare/////////////////////////////////////////////

  function clearForm(form) {
    // iterate over all of the inputs for the form
    // element that was passed in
    $(':input', form).each(function() {
      var type = this.type;
      var tag = this.tagName.toLowerCase(); // normalize case
      // it's ok to reset the value attr of text inputs,
      // password inputs, and textareas
      if (type == 'text' || type == 'password' || tag == 'textarea')
        this.value = "";
      // checkboxes and radios need to have their checked state cleared
      // but should *not* have their 'value' changed
      else if (type == 'checkbox' || type == 'radio')
        this.checked = false;
      // select elements need to have their 'selectedIndex' property set to -1
      // (this works for both single and multiple select elements)
      else if (tag == 'select')
        this.selectedIndex = -1;
    });
  };
  ///////////////////////////////SLIDE DOWN & UP TOOLBAR//////////////////////////////////////////////////

  $("#signup").click(function (){
    if( $(this).find(".details").css("display") == "none"){
      $(".details").slideDown(350);
    }
  });

  $("#signup a").click(function (){
    clearForm($("#signup form"));
    $(".details").slideUp(350);
  });

});
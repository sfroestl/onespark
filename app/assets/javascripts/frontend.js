
var scroll = $('.scroll-pane');
var content = $('.content');

var headHeight = $('.head').height();
var sidebarWidth = ($('.sidebar').width())*2 + 1;

/*
function refreshNav() {
    var pane = content;
    var api = pane.data('jsp');
    api.reinitialise();
}
*/

var toolheight = function(){
	var height = (($(window).height()) - headHeight).toString();
	console.log("toolHeight: "+height);
	scroll.css("height", height + "px");
};

var contentWidth = function(){
	var width = (($(window).width()) - sidebarWidth).toString();
	console.log("contentWidth: "+width + "windowWidth: "+ $(window).width().toString());
	content.css("width", width + "px");
	content.css("float", "left");
};

var headerSpacing = function(selector){
	var s1 = $(selector);
	var s1margin = (0 - s1.height() / 2 + 2).toString();
	console.log(s1margin);
	s1.css('margin-top',s1margin+'px');
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

////////////////////////////////FENSTER GELADEN//////////////////////////////////////////////////

 $(window).ready(
 	toolheight(), 
 	contentWidth(), 
 	headerSpacing('#projectHead h3'), 
 	headerSpacing('#toolHead h3'),
 	headerSpacing('#contentHead h3')
 );
var api = $('.scroll-pane').jScrollPane().data('jsp');

$(window).resize(function(){
	$(".jspVerticalBar").css("display", "none").delay(200).fadeIn(200);
	$(".content").css("width", "50%");
	contentWidth();
	toolheight();
	console.log(api);
	api.reinitialise();
});
// $(window).resize(function(){
// 	contentWidth();
// });

$("#projectHead").click(function(){
	contentWidth();
	toolheight();
	console.log(api);
	api.reinitialise();
});

////////////////////////////////SCROLLBAR CODE//////////////////////////////////////////////////
// Scrollbar-Replacement

$(function()
{
	$('.scroll-pane').each(
		function()
		{
			$(this).jScrollPane(
				{
					showArrows: $(this).is('.arrow')
				}
			);
			var api = $(this).data('jsp');
			var throttleTimeout;
			$(window).bind(
				'resize',
				function()
				{
					if ($.browser.msie) {
						// IE fires multiple resize events while you are dragging the browser window which
						// causes it to crash if you try to update the scrollpane on every one. So we need
						// to throttle it to fire a maximum of once every 50 milliseconds...
						if (!throttleTimeout) {
							throttleTimeout = setTimeout(
								function()
								{
									api.reinitialise();
									throttleTimeout = null;
								},
								50
							);
						}
					} else {
						api.reinitialise();
					}
				}
			);
		}
	)

});
$(function()
{
	$('.scroll-pane').jScrollPane(
		{
			hijackInternalLinks: true,
			animateScroll: false,
			autoReinitialise: true
		}
	);
});



///////////////////////////////SLIDE DOWN & UP TOOLBAR//////////////////////////////////////////////////

$("#add").click(function (){
	if( $(this).find(".details").css("display") == "none"){
		$(".details").slideDown(500);
	}
	api.reinitialise();
});
$("#add a").click(function (){
	clearForm($("#add form"));
	$(".details").slideUp(500);
});

// removes Form's Error Class, when User types new Letters
$(function(){
	if($('.field_with_errors').length){
		
		var field = $('.field_with_errors');
		var input = field.find('input');

		input.keydown(function(){
			$(this).parent().removeClass('field_with_errors');
		})
	}
});
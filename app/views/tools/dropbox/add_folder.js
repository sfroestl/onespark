console.log("Adding Folder");

$('.tool').removeClass('active');
$('.tool.add').addClass('active');
$('#add form').replaceWith('<%= escape_javascript(render(:partial => "tools/dropbox/form_folder")) %>');

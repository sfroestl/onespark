

console.log("DropBox show")
$('.sidebar2').replaceWith('<%= escape_javascript(render(:partial => "tools/dropbox/sidebar")) %>');

$('#dropbox_content').replaceWith('<%= escape_javascript(render(:partial => "tools/dropbox/content")) %>');


// content




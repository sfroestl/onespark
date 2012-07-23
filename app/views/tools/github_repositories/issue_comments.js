//  search clicked element
var element_title = '<%= @issue.title %>';
//  display data
$('.element:contains('+ element_title +')').find('#issue_comments').html('<%= escape_javascript render("issue_comments") %>');

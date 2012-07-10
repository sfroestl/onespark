require 'spec_helper'

describe "postings/edit" do
  before(:each) do
    @posting = assign(:posting, stub_model(Posting))
  end

  it "renders the edit posting form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => postings_path(@posting), :method => "post" do
    end
  end
end

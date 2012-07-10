require 'spec_helper'

describe "postings/new" do
  before(:each) do
    assign(:posting, stub_model(Posting).as_new_record)
  end

  it "renders new posting form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => postings_path, :method => "post" do
    end
  end
end

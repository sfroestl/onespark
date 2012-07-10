require 'spec_helper'

describe "postings/index" do
  before(:each) do
    assign(:postings, [
      stub_model(Posting),
      stub_model(Posting)
    ])
  end

  it "renders a list of postings" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end

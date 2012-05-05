require 'spec_helper'

describe "Static pages" do
  
subject { page }

  shared_examples_for "all static pages" do
      it { should have_selector('h1',    text: heading) }
      it { should have_selector('title', text: full_title(page_title)) }
    end

    describe "Home page" do
      before { visit root_path }
      let(:heading)    { 'Welcome to One Spark' }
      let(:page_title) { '' }

      it_should_behave_like "all static pages"
      it { should_not have_selector 'title', text: '| Home' }
      it { should have_selector '.btn-large', text: 'Sign up now' }
      it { should have_selector '.btn-large', text: 'Learn more' }
    end

end
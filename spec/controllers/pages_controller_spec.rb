require 'spec_helper'

describe PagesController do

render_views

before(:each) do
    @base_titre = "Simple App du Tutoriel Ruby on Rails"
  end


  describe "GET 'home'" do
    it "should be successful" do
      get 'home'
      response.should be_success
    end

    it "doit avoir le bon titre" do
      get 'home'
      response.should have_selector("title", :content => "Home")
    end

  end

  describe "GET 'contact'" do
    it "should be successful" do
      get 'contact'
      response.should be_success
    end
  end

  describe "GET 'about'" do
    it "should be successful" do
      get 'about'
      response.should be_success
    end
  end





 describe "GET 'home'" do

    describe "quand pas identifie" do

      before(:each) do
        get :home
      end

      it "devrait reussir" do
        response.should be_success
      end

      it "devrait avoir le bon titre" do
        response.should have_selector("title",
                                      :content => "#{@base_titre} | Home")
      end
    end

    describe "quand identifie" do

      before(:each) do
        @user = test_sign_in(Factory(:user))
        other_user = Factory(:user, :email => Factory.next(:email))
        other_user.follow!(@user)
      end

      it "devrait avoir le bon compte d'auteurs et de lecteurs" do
        get :home
     response.should have_selector("a", :href => following_user_path(@user),
                                           :content => "0 auteur")

     response.should have_selector("span", :content => "1 lecteur")
      end
    end
  end





end

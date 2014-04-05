require 'spec_helper'

describe RelationshipsController do

  describe "Le controle d'acces" do

    it "devrait exiger l'identification pour creer" do
      post :create
      response.should redirect_to(signin_path)
    end

    it "devrait exiger l'identification pour detruire" do
      delete :destroy, :id => 1
      response.should redirect_to(signin_path)
    end
  end

  describe "POST 'create'" do

    before(:each) do
      @user = test_sign_in(Factory(:user))
      @followed = Factory(:user, :email => Factory.next(:email))
    end

    it "devrait creer une relation" do
      lambda do
        post :create, :relationship => { :followed_id => @followed }
        response.should be_redirect
      end.should change(Relationship, :count).by(1)
    end


    it "devrait creer une relation en utilisant Ajax" do
      lambda do
        xhr :post, :create, :relationship => { :followed_id => @followed }
        response.should be_success
      end.should change(Relationship, :count).by(1)
    end
  end

  describe "DELETE 'destroy'" do

    before(:each) do
      @user = test_sign_in(Factory(:user))
      @followed = Factory(:user, :email => Factory.next(:email))
      @user.follow!(@followed)
      @relationship = @user.relationships.find_by_followed_id(@followed)
    end

    it "devrait detruire une relation" do
      lambda do
        delete :destroy, :id => @relationship
        response.should be_redirect
      end.should change(Relationship, :count).by(-1)
    end

    it "devrait detruire une relation en utilisant Ajax" do
      lambda do
        xhr :delete, :destroy, :id => @relationship
        response.should be_success
      end.should change(Relationship, :count).by(-1)
    end
  end
end



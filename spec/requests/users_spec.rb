require 'spec_helper'

describe "Users" do

  describe "Une inscription" do

    describe "ratee" do

      it "ne devrait pas creer un nouvel utilisateur" do
        lambda do
          visit signup_path
          fill_in "Nom", :with => ""
          fill_in "email", :with => ""
          fill_in "Date naissance", :with => ""
	  fill_in "Poids ideal", :with => ""
	  fill_in "Poids actuel", :with => ""
	  fill_in "Taille", :with => ""
          fill_in "password", :with => ""
          fill_in "Confirmation", :with => ""
          click_button
          response.should render_template('users/new')
          response.should have_selector("div#error_explanation")
        end.should_not change(User, :count)
      end
    end

    describe "reussie" do

      it "devrait creer un nouvel utilisateurr" do
        lambda do
          visit signup_path
          fill_in "Nom", :with => "Example User"
          fill_in "email", :with => "user@example.com"
          fill_in "Date naissance", :with => "16-05-1990"
	  fill_in "Poids ideal", :with => "75.5"
	  fill_in "Poids actuel", :with => "80.5"
	  fill_in "Taille", :with => "175"
          fill_in "password", :with => "foobar"
	  fill_in "Confirmation", :with => "foobar"
          click_button
          response.should have_selector("div.flash.success",
                                        :content => "Bienvenue")
          response.should render_template('users/show')
        end.should change(User, :count).by(1)
      end
    end



  end

 describe "identification/deconnexion" do

    describe "l'echec" do
     it "ne devrait pas identifier l'utilisateur" do

        visit signin_path
        fill_in "eMail",    :with => ""
        fill_in "Mot de passe", :with => ""
        click_button
        #response.should have_selector("div.flash.error", :content => "Invalid")


      end
    end

    describe "le succes" do
      it "devrait identifier un utilisateur puis le deconnecter" do
        user = Factory(:user)
        visit signin_path
        fill_in "eMail",    :with => user.email
        fill_in "Mot de passe", :with => user.password
        click_button
        controller.should be_signed_in
        click_link "Deconnexion"
        controller.should_not be_signed_in
      end
    end
  end

end

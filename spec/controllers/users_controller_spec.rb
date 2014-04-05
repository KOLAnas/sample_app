require 'spec_helper'

describe UsersController do
render_views

  describe "GET 'index'" do

    describe "pour utilisateur non identifies" do
      it "devrait refuser l'acces" do
        get :index
        response.should redirect_to(signin_path)
        flash[:notice].should =~ /sign in/i
      end
    end

    describe "pour un utilisateur identifie" do

      before(:each) do
        @user = test_sign_in(Factory(:user))
        second = Factory(:user, :email => "another@example.com")
        third  = Factory(:user, :email => "another@example.net")

         @users = [@user, second, third]
        30.times do
          @users << Factory(:user, :email => Factory.next(:email))
        end
      end



      it "devrait reussir" do
        get :index
        response.should be_success
      end

      it "devrait avoir le bon titre" do
        get :index
        response.should have_selector("title", :content => "Liste des utilisateurs")
      end

      it "devrait avoir un element pour chaque utilisateur" do
        get :index
   @users[0..2].each do |user|
          response.should have_selector("li", :content => user.nom)
        end
      end


      it "devrait paginer les utilisateurs" do
        get :index
        response.should have_selector("div.pagination")
        response.should have_selector("span.disabled", :content => "Previous")
        response.should have_selector("a", :href => "/users?page=2",
                                           :content => "2")
        response.should have_selector("a", :href => "/users?page=2",
                                           :content => "Next")
      end
    end
  end







  describe "GET 'show'" do

    before(:each) do
      @user = Factory(:user)
    end

    it "devrait reussir" do
      get :show, :id => @user
      response.should be_success
    end

    it "devrait trouver le bon utilisateur" do
      get :show, :id => @user
      assigns(:user).should == @user
    end

 it "devrait avoir le bon titre" do
      get :show, :id => @user
      response.should have_selector("title", :content => @user.nom)
    end

    it "devrait inclure le nom de l'utilisateur" do
      get :show, :id => @user
      response.should have_selector("h1", :content => @user.nom)
    end

    it "devrait avoir une image de profil" do
      get :show, :id => @user
      response.should have_selector("h1>img", :class => "gravatar")
    end

    it "devrait afficher les micro-messages de l'utilisateur" do
      mp1 = Factory(:micropost, :user => @user, :content => "Foo bar")
      mp2 = Factory(:micropost, :user => @user, :content => "Baz quux")
      get :show, :id => @user
      response.should have_selector("span.content", :content => mp1.content)
      response.should have_selector("span.content", :content => mp2.content)
    end
  end





  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end

it "devrait avoir le titre adequat" do
      get 'new'
      response.should have_selector("title", :content => "Inscription")
    end
  end




  describe "POST 'create'" do

    describe "echec" do

      before(:each) do
        @attr = { :nom => "", :email => "", :date_naissance => "",  :poids_actuel => "", :poids_ideal => "", :taille => "", :password => "",
                  :password_confirmation => ""  }
      end

      it "ne devrait pas creer d'utilisateur" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count)
      end

      it "devrait avoir le bon titre" do
        post :create, :user => @attr
        response.should have_selector("title", :content => "Inscription")
      end

      it "devrait rendre la page 'new'" do
        post :create, :user => @attr
        response.should render_template('new')
      end


 describe "succes" do

      before(:each) do
        @attr = { :nom => "New User", :email => "user@example.com", :date_naissance => "16/05/1990", :poids_ideal =>"75.5", :poids_actuel => "80.5", :taille => "175",  :password => "foobar", :password_confirmation => "foobar" }
      end

      it "devrait creer un utilisateur" do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1)
      end

      it "devrait rediriger vers la page d'affichage de l'utilisateur" do
        post :create, :user => @attr
        response.should redirect_to(user_path(assigns(:user)))
      end   

      it "devrait identifier l'utilisateur" do
        post :create, :user => @attr
        controller.should be_signed_in
      end



    it "devrait avoir un message de bienvenue" do
        post :create, :user => @attr
        flash[:success].should =~ /Bienvenue dans l'Application Exemple/i
      end 
    end
    end
  end


  def create
    @user = User.new(params[:user])
    if @user.save
      # Traite un succès d'enregistrement.
    else
      @titre = "Inscription"

      render 'new'
    end
  end


  describe "GET 'edit'" do

    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end

    it "devrait reussir" do
      get :edit, :id => @user
      response.should be_success
    end

    it "devrait avoir le bon titre" do
      get :edit, :id => @user
      response.should have_selector("title", :content => "Edition profil")
    end

    it "devrait avoir un lien pour changer l'image Gravatar" do
      get :edit, :id => @user
      gravatar_url = "http://gravatar.com/emails"
      response.should have_selector("a", :href => gravatar_url,
                                         :content => "changer")
    end
  end


  describe "PUT 'update'" do

    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end

    describe "Echec" do

      before(:each) do
        @attr = { :email => "", :nom => "",:date_naissance => "", :poids_ideal => "", :taille => "", :poids_actuel => "", :password => "",
                  :password_confirmation => "" }
      end

      it "devrait retourner la page d'edition" do
        put :update, :id => @user, :user => @attr
        response.should render_template('edit')
      end

      it "devrait avoir le bon titre" do
        put :update, :id => @user, :user => @attr
        response.should have_selector("title", :content => "Edition profil")
      end
    end

    describe "succes" do

      before(:each) do
        @attr = { :nom => "New Name", :email => "user@example.org", :date_naissance => "16/06/1990", :poids_ideal => "75.5",:taille => "175", :poids_actuel => "90",   :password => "barbaz", :password_confirmation => "barbaz" }
      end

      it "devrait modifier les caracteristiques de l'utilisateur" do
        put :update, :id => @user, :user => @attr
        @user.reload
        @user.nom.should  == @attr[:nom]
        @user.email.should == @attr[:email]
      end

      it "devrait rediriger vers la page d'affichage de l'utilisateur" do
        put :update, :id => @user, :user => @attr
        response.should redirect_to(user_path(@user))
      end

      it "devrait afficher un message flash" do
        put :update, :id => @user, :user => @attr
        flash[:success].should =~ /actualise/
      end
    end
  end

  describe "authentification des pages edit/update" do

    before(:each) do
      @user = Factory(:user)
    end








    describe "pour un utilisateur non identifie" do

      it "devrait refuser l'accces a l'action 'edit'" do
        get :edit, :id => @user
        response.should redirect_to(signin_path)
      end

      it "devrait refuser l'acces a l'action 'update'" do
        put :update, :id => @user, :user => {}
        response.should redirect_to(signin_path)
      end
    end









    describe "pour un utilisateur identifie" do

      before(:each) do
        wrong_user = Factory(:user, :email => "user@example.net")
        test_sign_in(wrong_user)
      end

      it "devrait correspondre a l'utilisateur a editer" do
        get :edit, :id => @user
        response.should redirect_to(root_path)
      end

      it "devrait correspondre a l'utilisateur a actualiser" do
        put :update, :id => @user, :user => {}
        response.should redirect_to(root_path)
      end
    end
  end



 describe "DELETE 'destroy'" do

    before(:each) do
      @user = Factory(:user)
    end

    describe "en tant qu'utilisateur non identifie" do
      it "devrait refuser l'acces" do

        delete :destroy, :id => @user
        response.should redirect_to(signin_path)
      end
    end



    describe "en tant qu'utilisateur non administrateur" do
      it "devrait proteger la page" do
        test_sign_in(@user)
        delete :destroy, :id => @user
        response.should redirect_to(root_path)
      end
    end

    describe "en tant qu'administrateur" do

      before(:each) do
        admin = Factory(:user, :email => "admin@example.com", :admin => true)
        test_sign_in(admin)
      end

      it "devrait detruire l'utilisateur" do
        lambda do
          delete :destroy, :id => @user
        end.should change(User, :count).by(-1)
      end

      it "devrait rediriger vers la page des utilisateurs" do
        delete :destroy, :id => @user
        response.should redirect_to(users_path)
      end
    end
  end





  describe "Les pages de suivi" do

    describe "quand pas identifie" do

      it "devrait proteger les auteurs suivis" do
   #     get :following, :id => 1
    #    response.should redirect_to(signin_path)
      end

      it "devrait proteger les lecteurs" do
     #   get :followers, :id => 1
      #  response.should redirect_to(signin_path)
      end
    end

    describe "quand identifie" do

      before(:each) do
        @user = test_sign_in(Factory(:user))
        @other_user = Factory(:user, :email => Factory.next(:email))
        @user.follow!(@other_user)
      end

      it "devrait afficher les auteurs suivis par l'utilisateur" do
        get :following, :id => @user
        response.should have_selector("a", :href => user_path(@other_user),
                                           :content => @other_user.nom)
      end

      it "devrait afficher les lecteurs de l'utilisateur" do
        get :followers, :id => @other_user
        response.should have_selector("a", :href => user_path(@user),
                                           :content => @user.nom)
      end
    end
  end


 end

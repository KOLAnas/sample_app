class UsersController < ApplicationController
 
 before_filter :authenticate, :except => [:show, :new, :create]

before_filter :authenticate, :only => [:index, :edit, :update, :destroy]
 before_filter :correct_user, :only => [:edit, :update]
 before_filter :admin_user,   :only => :destroy






def following
    @titre = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(:page => params[:page])
    render 'show_follow'
  end

  def followers
    @titre = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(:page => params[:page])
    render 'show_follow'
  end






  def index
    @titre = "Liste des utilisateurs"
     @users = User.paginate(:page => params[:page])
  end

 
def new
	
	@user = User.new
        @titre = "Inscription"
	 
end

  def create
    @user = User.new(params[:user])

    if @user.save

     sign_in @user
    flash[:success] = "Bienvenue dans l'Application Exemple!"
	
       redirect_to @user
    else
      @titre = "Inscription"
      render 'new'
    end
  end


  def edit
    @user = User.find(params[:id])
    @titre = "Edition profil"
  end


def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(:page => params[:page])
    @titre = @user.nom
end  

def  cv
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(:page => params[:page])
    @titre = @user.nom
end 

def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profil actualise."
      redirect_to @user
    else
      @titre = "Edition profil"
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "Utilisateur supprime."
    redirect_to users_path
  end





  private

    def authenticate
      deny_access unless signed_in?
    end

  def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

  def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

end

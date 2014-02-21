class UsersController < ApplicationController
<<<<<<< HEAD

 def show
    @user = User.find(params[:id])
  end  
=======
  
def show
    @user = User.find(params[:id])
end
>>>>>>> modeling-users

def new
	@titre = "Inscription"
end

end

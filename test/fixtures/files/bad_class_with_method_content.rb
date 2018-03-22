class UsersController < Admin::BaseController
  before_action :set_user, only: [:edit, :update, :destroy]

  # GET /users
  def index
    @users = User.ordered.filter(params[:q]).page(params[:page]).includes(:kai)
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  def create
    generated_password = Devise.friendly_token
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      redirect_to admin_users_url, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    redirect_to admin_users_url, notice: 'User was successfully destroyed.'
  end
end

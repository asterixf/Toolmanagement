class UsersController < ApplicationController

  def index
    @tools = policy_scope(Tool)
    @users = User.all.order(:id)
    authorize @users
  end

  # def show
  #   @user = User.find(params[:id])
  #   authorize @user
  # end

  def new
    @user = User.new
    authorize @user
  end

  def create
    @user = User.new(user_params)
    authorize @user
    if @user.save
      redirect_to users_path
      flash[:notice] = "User created successfully"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @user = User.find(params[:id])
    authorize @user
  end

  def update
    @user = User.find(params[:id])
    authorize @user
    if params[:user][:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end
    if @user.update(user_params)
      redirect_to users_path
      flash[:notice] = "User updated successfully"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :lastname, :plant, :department, :position, :email, :password, :admin)
  end
end

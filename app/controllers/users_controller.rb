class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
    @companies = Company.all
    @orders = Order.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
    @company = @user.companies.build
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    if @user.save
              # binding.pry

      if !params[:user][:companies].nil?
        binding.pry
        # params[:companies].each do |c|
          # @companies = @user.companies.create(params[:companies])
          @user.companies(params[:user]).create(:company => params[:user][:companies])
          # @user.companies.create(:companies => params[:user][:companies])
        # end

        # @model.model_attachments(params[:model]).create(:avatar => a)
      end
      redirect_to @user
    else
      render :new
    end

# if @model.save

#       if !params[:model_attachments].nil?
#         params[:model_attachments]['avatar'].each do |a|
#           @model_attachment = @model.model_attachments.create(:avatar => a)
#         end
#       else
#         @model_attachments = []
#       end
#       redirect_to action: "edit", id: @model.id
#     else
#       render action: 'new'
#     end




    # respond_to do |format|
    #   if @user.save
    #     format.html { redirect_to @user, notice: 'User was successfully created.' }
    #     format.json { render :show, status: :created, location: @user }
    #   else
    #     format.html { render :new }
    #     format.json { render json: @user.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :fname, :lname, :password, :password_confirmation, :status, :apps_manager, :phone, :description)
    end

    def company_params
      params.require(:company).permit(:title, :email, :status, :domain_id, :city, :street, :postal_code, :phone, :description)
    end
end

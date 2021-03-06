class ReponsesController < ApplicationController
before_action :find_test
before_action :find_reponse, only: [:edit, :update, :show]
before_filter :admin?, only: [:edit, :update, :destroy]
before_filter :authenticate_user!, only: [:new, :create, :show]
#before_action :user_average, only: [:show]



    def show
      if @reponse.test_id != @test.id
        redirect_to root_path
      end
      @user = current_user
    end

    def new
      redirect_to root_path unless @test.video.online? || current_user.role == 'admin'
      @reponse = Reponse.new
    end

    def create
      @reponse = Reponse.new(reponse_params)
      @reponse.test_id = @test.id
      @reponse.user_id = current_user.id
      @reponse.user_username = current_user.username
      @reponse.email = current_user.email
      @reponse.console_id = @test.console_id

      if @reponse.save
        redirect_to test_path(@test) #show
      else
        render 'new'
      end
    end

    def edit
    end

    def update
      if @reponse.update(reponse_params)
        redirect_to test_reponse_path(@test, @reponse)
      else
        render 'edit'
      end
    end


    def destroy
      @reponse.destroy
      redirect_to pages_adminpage_path
    end



  private

    def reponse_params
      params.require(:reponse).permit(:test_id, :user_username, :reponse_1, :reponse_2, :reponse_3, :reponse_4, :note_1, :note_2, :note_3, :note_4, :total, :email, :appreciation)
    end

    def find_test
      @test = Test.find(params[:test_id])
    end

    def find_reponse
      @reponse = Reponse.find(params[:id])
    end

=begin
    def user_average
      @user = User.where(username: @reponse.user_username).first
      @userreponse = Reponse.where(["total is NOT NULL"]).where(user_username: @user.username)

        if @userreponse.count >= 2
          @user.update average: @userreponse.average(:total).round(2)
        end
    end
=end

end

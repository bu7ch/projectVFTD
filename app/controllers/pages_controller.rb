class PagesController < ApplicationController
#before_action :find_user, only: [:destroy]
before_action :update_presence, only: [:index]
#before_filter :update_score, only: [:halloffame]
before_filter :admin?, only: [:adminpage]
before_action :authenticate_user!, only: [:casier]
before_filter :nanda, only: [:correspondances]
layout :resolve_layout


  def index
    @user = current_user
    @video = Video.last
    @console = Console.find(@video.console_id)
    @post = Post.last
    @comment = Comment.last
    @goodreponses = Reponse.where("total is NOT NULL").where("user_username != 'Papako'" )

    @goodusers = User.where("role != 'admin'")
    @topten = @goodusers.order('score desc').first(10)
    #@topten2 = @topten.order('score asc')

    if signed_in?
    @userreponse = Reponse.where(["total is NOT NULL"]).where(user_username: @user.username)
    end
  end

  def videos
  end

  def casier
    @user = current_user
    @userreponse = Reponse.where(["total is NOT NULL"]).where(user_username: @user.username)
    @goodreponses = Reponse.where("total is NOT NULL").where("role != 'admin'")
    @uservisits = Visit.where(user_username: @user.username)
    @goodusers = User.where(["average is NOT NULL"]).where("role != 'admin'")
    @goodusers_two = User.where("role != 'admin'")
    @rank = @goodusers_two.order('sign_in_count desc').index(@user)
    @ranknote = @goodusers.order('score desc').index(@user)

  end

  #def forum
  #end

  def faq
  end

  def cooperative
  end

  def adminpage

    @users = User.all.order("created_at DESC")
    @posts = Post.all.order("created_at DESC")
    @visits = Visit.all.order("created_at DESC").limit(50)
    @videos = Video.all.order("created_at DESC")
    @comments = Comment.all.order("created_at DESC")
    @consoles = Console.all.order("created_at DESC")
    @tests = Test.all.order("created_at DESC")
    @reponsesacorriger = Reponse.where(total: nil)
    #@testsrandom = Test.all.order("RANDOM()").limit(3)
  end

  def correspondances
  end

  def halloffame
    @goodusers_average = User.where(["average is NOT NULL"]).where("role != 'admin'")
    @topten = @goodusers_average.order('score desc')
  end

  private

  def update_presence
    if signed_in?
      @user = current_user

      if @user.presence == nil
        @user.update presence: 1

      elsif @user.role != "admin" && @user.updated_at != Time.now
      @user.update presence: @user.presence + 1
      end

    end
  end


  def nanda
    if signed_in?
      redirect_to root_path unless current_user.role == "admin" || current_user.role == "nanda"
    else
      redirect_to root_path
    end
  end


  def resolve_layout
    case action_name
    when "videos"
      "videos"
    when "adminpage"
      "adminpage"
    when "casier"
      "casier"
    when "faq"
      "faq"
    when "cooperative"
      "cooperative"
    else
      "application"
    end
  end

end

class Reponse < ActiveRecord::Base
belongs_to :test
belongs_to :user


  after_update :correction, :if => :total_changed?
  after_save :acorriger

  @bigtotal = Reponse.all.map { |reponse| reponse.total }


  validates :user_username, uniqueness: { scope: [:user_username, :test_id], message: "Tu as déjà passé ce DST !"}


  def correction
    UserMailer.correction(self).deliver_later
  end

  def acorriger
    UserMailer.acorriger(self).deliver_later
  end

  def moyenne
    @goodreponses = Reponse.where("total is NOT NULL")
    @arraygoodtotal = @goodreponses.map { |reponse| reponse.total }
  end



end

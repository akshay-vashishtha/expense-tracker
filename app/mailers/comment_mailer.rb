class CommentMailer < ApplicationMailer
  def notify_user
    mail(to: params[:email], subject: "#{params[:sender]} commented on #{params[:user]}")
  end
end

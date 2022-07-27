class Api::CommentController < ApplicationController
    def index 
        comments = Comment.all
        render json: comments
    end

    def self.add_comment (obj)
        @comment = Comment.new(obj)
        unless @comment.save
            render json: {  "error": "comment creation failed"  }, status: 501
        end
    end

    def self.notify_user (user)
        CommentMailer.with(email: user[:user_email], sender: "admin", user: user[:user_handle], title: user[:title]).notify_user.deliver_now
    end
end

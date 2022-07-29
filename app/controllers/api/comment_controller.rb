class Api::CommentController < ApplicationController
    def index 
        comments = Comment.all
        render json: comments
    end

    def add_comment
        data = json_payload
        comment = Comment.new(data)
        if params[:id] == "admin"
            authorize_admin
            comment.user_email = "admin@yubi.com"
        else 
        authorize_employee
            comment.user_email = current_user.email
        end
        comment.user = current_user.user_handle
        if comment.save
            render json: { "message": "commented successfully" }, status: 201
        else
            render json: {  "error": "comment creation failed"  }, status: 501
        end
    end
end

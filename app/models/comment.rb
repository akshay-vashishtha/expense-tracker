class Comment < ApplicationRecord
    belongs_to :expense
    after_save :notify_user
    private

    def notify_user
        CommentMailer.with(email: self[:user_email], sender: self[:user_email], user: self[:user], title: self[:description]).notify_user.deliver_now
    end
end

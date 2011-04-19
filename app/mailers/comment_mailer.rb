class CommentMailer < ActionMailer::Base
  default :to => "jsveholm@riec.tohoku.ac.jp"

  def comment_confirmation(comment)
    @comment = comment
    mail(:subject => "RIEC News Comment",
         :from => comment.name)
  end
end

module ApplicationHelper
  def vote_state(vote_val)
    vote_class = {}
    if vote_val == 0 || vote_val == nil
      vote_class["up"] = 'in-active'
      vote_class["down"] = 'in-active'
    elsif vote_val == 1
      vote_class["up"] = ''
      vote_class["down"] = 'in-active'
    elsif vote_val == -1
      vote_class["up"] = 'in-active'
      vote_class["down"] = ''
    end
    return vote_class
  end

  def find_comment_vote_val(comment_id, user_id)
    if CommentVote.exists?(comment_id: comment_id, user_id: user_id)
      return CommentVote.find_by(comment_id: comment_id, user_id: user_id).vote_val 
    else
      return 0
    end
  end
end

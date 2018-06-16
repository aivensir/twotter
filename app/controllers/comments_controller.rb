class CommentsController < ApplicationController
  def return_comments
    render :json => {'text' => 'hello_comments'}
  end

  def create_new_comment
    user = User.where(:auth_token => params[:auth_token]).first
    if user.blank?
      render :json => {'error' => "You're not logged in."}, :status => :forbidden
      return
    end

    fail = {'error' => 'Null'}
    if params[:text].blank?
      render :json => fail, :status => :forbidden
      return
    end

    a = Post.where(:id => params[:post_id]).first
    comment = a.comments.create(text: params[:text])
    comment.user_id = user.id
    comment.save!
    hh = {'post_id' => comment.post_id, 'text' => comment.text, 'likes' => comment.likes.count, 'liked' => 0, 'date' => comment.updated_at.to_s, 'comment_id' => comment.id, 'username' => User.find(comment.user_id).username }
    render :json => hh, :status => :created
  end

  def edit_comment
    user = User.where(:auth_token => params[:auth_token]).first
    if user.blank?
      render :json => {'error' => "You're not logged in."}, :status => :forbidden
      return
    end

    fail = {'comment_text' => 'Null'}
    if params[:text].blank?
      render :json => fail, :status => :forbidden
      return
    end

    comment = Comment.where(:id => params[:comment_id]).first
    if comment.user_id != user.id
      render :json =>{'error' => "This post isn't yours"}, :status => :forbidden
      return
    end

    if comment.blank?
      render :json => {'error' => 'Null'}, :status => :not_found
      return
    end

    liked = (user.likes.where(:comment_id => comment.id).blank?) ? 0 : 1
    comment.text = params[:text]

    fail = {'error' => 'Null'}
    comment.save ? (render :json => {'post_id' => comment.post_id,
                                     'text' => comment.text,
                                     'likes' => comment.likes.count,
                                     'liked' => liked,
                                     'date' => comment.updated_at.to_s,
                                     'comment_id' => comment.id,
                                     'username' => User.find(comment.user_id).username },
                           :status => :ok) : (render :json => fail, :status => :service_unavailable)
  end


  def remove_comment
    user = User.where(:auth_token => params[:auth_token]).first
    if user.blank?
      render :json => {'error' => "You're not logged in."}, :status => :forbidden
      return
    end
    comment = Comment.where(:id => params[:comment_id]).first
    if comment.user_id != user.id
      render :json =>{'error' => "This post isn't yours"}, :status => :forbidden
      return
    end
    if comment.blank?
      render :json => {'comment_id' => 'Null'}, :status => :not_found
      return
    end
    liked = (user.likes.where(:comment_id => comment.id).blank?) ? 0 : 1
    hh = {'post_id' => comment.post_id, 'text' => comment.text, 'likes' => comment.likes.count, 'liked' => liked, 'date' => comment.updated_ad.to_s, 'comment_id' => comment.id, 'username' => User.find(comment.user_id).username}
    fail = {'error' => 'Null'}
    comment.destroy ? (render :json => hh, :status => :ok) : (render :json => fail, :status => :service_unavailable)
  end


  def like
    #params auth_token, comment_id
    user = User.where(:auth_token => params[:auth_token]).first
    if user.blank?
      render :json => {'error' => "You're not logged in."}, :status => :forbidden
      return
    end
    comment = Comment.where(:id => params[:comment_id]).first
    # if comment.user_id != user.id
    #   render :json =>{'error' => "This comment isn't yours"}, :status => :forbidden
    #   return
    # end

    if comment.blank?
      render :json => {'error' => 'Null'}, :status => :not_found
      return
    end

    if !user.likes.where(:comment_id => comment.id).first.blank?
      render :json => {'error' => "Do not try to cheat in there."}, :status => :forbidden
      return
    end
    user.likes.create(comment_id: comment.id, post_id: 0)
    #comment.likes_count = user.likes.count

    hh = {'post_id' => comment.post_id, 'text' => comment.text, 'likes' => comment.likes.count, 'liked' => 1, 'date' => comment.updated_at.to_s, 'comment_id' => comment.id, 'username' => User.find(comment.user_id).username}
    fail = {'comment_id' => 'Null'}

    comment.save ? (render :json => hh, :status => :ok) : (render :json => fail, :status => :service_unavailable)
  end

  def dislike
  #params auth_token, comment_id
    user = User.where(:auth_token => params[:auth_token]).first
    if user.blank?
      render :json => {'error' => "You're not logged in."}, :status => :forbidden
      return
    end
    comment = Comment.where(:id => params[:comment_id]).first
    # if comment.user_id != user.id
    #   render :json =>{'error' => "This comment isn't yours"}, :status => :forbidden
    #   return
    # end

    if comment.blank?
      render :json => {'error' => 'Null'}, :status => :not_found
      return
    end

    if user.likes.where(:comment_id => comment.id).first.blank?
      render :json => {'error' => "Do not try to cheat in there."}, :status => :forbidden
      return
    end
    user.likes.where(:comment_id => comment.id).first.destroy
    #comment.likes_count = user.likes.count

    hh = {'post_id' => comment.post_id, 'text' => comment.text, 'likes' => comment.likes.count, 'liked' => 0, 'date' => comment.updated_at.to_s, 'comment_id' => comment.id, 'username' => User.find(comment.user_id).username}
    fail = {'comment_id' => 'Null'}

    comment.save ? (render :json => hh, :status => :ok) : (render :json => fail, :status => :service_unavailable)
  end
end

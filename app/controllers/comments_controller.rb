class CommentsController < ApplicationController
  @@err_null = {:error => "Null"}
  @@err_log = {:error => "You're not logged in"}
  @@err_commnull = {:comment_id => "Null"}

  def return_comments
    render :json => {:text => "Hello_comments"}
  end

  def create_new_comment
    user = User.where(:auth_token => params[:auth_token]).first
    if user.blank?
      render :json => @@err_log, :status => :forbidden
      return
    end

    if params[:text].blank?
      render :json => @@err_null, :status => :forbidden
      return
    end

    a = Post.where(:id => params[:post_id]).first
    comment = a.comments.create(text: params[:text])
    comment.user_id = user.id
    comment.save!
    render :json => {:post_id => comment.post_id,
      :text => comment.text,
      :likes => comment.likes.count,
      :liked => 0,
      :date => comment.updated_at.to_s,
      :comment_id => comment.id,
      :username => User.find(comment.user_id).username }, :status => :created
  end

  def edit_comment
    user = User.where(:auth_token => params[:auth_token]).first
    if user.blank?
      render :json => @@err_log, :status => :forbidden
      return
    end

    if params[:text].blank?
      render :json => {:comment_text => 'Null'}, :status => :forbidden
      return
    end

    comment = Comment.where(:id => params[:comment_id]).first
    if comment.user_id != user.id
      render :json =>{:error => "This post isn't yours"}, :status => :forbidden
      return
    end

    if comment.blank?
      render :json => @@err_null, :status => :not_found
      return
    end

    liked = (user.likes.where(:comment_id => comment.id).blank?) ? 0 : 1
    comment.text = params[:text]
    comment.save ? (render :json => {:post_id => comment.post_id,
                                     :text => comment.text,
                                     :likes => comment.likes.count,
                                     :liked => liked,
                                     :date => comment.updated_at.to_s,
                                     :comment_id => comment.id,
                                     :username => User.find(comment.user_id).username },
                           :status => :ok) : (render :json => @@err_null, :status => :service_unavailable)
  end


  def remove_comment
    user = User.where(:auth_token => params[:auth_token]).first
    if user.blank?
      render :json => @@err_log, :status => :forbidden
      return
    end
    comment = Comment.where(:id => params[:comment_id]).first
    if comment.user_id != user.id
      render :json =>{:error => "This post isn't yours"}, :status => :forbidden
      return
    end
    if comment.blank?
      render :json => @@err_commnull, :status => :not_found
      return
    end
    liked = (user.likes.where(:comment_id => comment.id).blank?) ? 0 : 1
    comment.destroy ? (render :json => {:post_id => comment.post_id,
      :text => comment.text,
      :likes => comment.likes.count,
      :liked => liked,
      :date => comment.updated_ad.to_s,
      :comment_id => comment.id,
      :username => User.find(comment.user_id).username}, :status => :ok) : (render :json => @@err_null, :status => :service_unavailable)
  end


  def like
    #params auth_token, comment_id
    user = User.where(:auth_token => params[:auth_token]).first
    if user.blank?
      render :json => @@err_log, :status => :forbidden
      return
    end
    comment = Comment.where(:id => params[:comment_id]).first
    # if comment.user_id != user.id
    #   render :json =>{'error' => "This comment isn't yours"}, :status => :forbidden
    #   return
    # end

    if comment.blank?
      render :json => @@err_null, :status => :not_found
      return
    end

    if !user.likes.where(:comment_id => comment.id).first.blank?
      render :json => {:error => "Do not try to cheat in there."}, :status => :forbidden
      return
    end
    user.likes.create(comment_id: comment.id, post_id: 0)
    #comment.likes_count = user.likes.count

    comment.save ? (render :json => {:post_id => comment.post_id,
      :text => comment.text,
      :likes => comment.likes.count,
      :liked => 1,
      :date => comment.updated_at.to_s,
      :comment_id => comment.id,
      :username => User.find(comment.user_id).username}, :status => :ok) : (render :json => @@err_commnull, :status => :service_unavailable)
  end

  def dislike
  #params auth_token, comment_id
    user = User.where(:auth_token => params[:auth_token]).first
    if user.blank?
      render :json => @@err_log, :status => :forbidden
      return
    end
    comment = Comment.where(:id => params[:comment_id]).first
    # if comment.user_id != user.id
    #   render :json =>{'error' => "This comment isn't yours"}, :status => :forbidden
    #   return
    # end

    if comment.blank?
      render :json => @err_null, :status => :not_found
      return
    end

    if user.likes.where(:comment_id => comment.id).first.blank?
      render :json => {:error => "Do not try to cheat in there."}, :status => :forbidden
      return
    end
    user.likes.where(:comment_id => comment.id).first.destroy
    #comment.likes_count = user.likes.count

    comment.save ? (render :json => {:post_id => comment.post_id,
      :text => comment.text,
      :likes => comment.likes.count,
      :liked => 0,
      :date => comment.updated_at.to_s,
      :comment_id => comment.id,
      :username => User.find(comment.user_id).username}, :status => :ok) : (render :json => @@err_commnull, :status => :service_unavailable)
  end
end

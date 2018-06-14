class CommentsController < ApplicationController
  def return_comments
    render :json => {'text' => 'hello_comments'}
  end

  def create_new_comment
    user = User.where(:auth_token => params[:auth_token]).first
    if user.blank?
      render :json => {'Error!' => "You're not logged in."}, :status => :forbidden
      return
    end

    fail = {'Error!' => 'Null'}
    if params[:text].blank?
      render :json => fail, :status => :forbidden
      return
    end

    a = Post.where(:id => params[:post_id]).first
    comment = a.comments.create(text: params[:text])
    comment.user_id = user.id
    comment.save!
    hh = {'post_id' => comment.post_id, 'text' => comment.text, 'likes' => comment.likes, 'date' => comment.created_at.to_s, 'comment_id' => comment.id, 'username' => User.find(comment.user_id).username }
    render :json => hh, :status => :created
  end

  def edit_comment
    user = User.where(:auth_token => params[:auth_token]).first
    if user.blank?
      render :json => {'Error!' => "You're not logged in."}, :status => :forbidden
      return
    end

    fail = {'comment_text' => 'Null'}
    if params[:text].blank?
      render :json => fail, :status => :forbidden
      return
    end

    comment = Comment.where(:id => params[:comment_id]).first
    if comment.user_id != user.id
      render :json =>{'Error!' => "This post isn't yours"}, :status => :forbidden
      return
    end

    if comment.blank?
      render :json => {'Error!' => 'Null'}, :status => :not_found
      return
    end
    comment.text = params[:text]

    hh = {'post_id' => comment.post_id, 'text' => comment.text, 'likes' => comment.likes, 'date' => comment.updated_at.to_s, 'comment_id' => comment.id, 'username' => User.find(comment.user_id).username }
    fail = {'Error!' => 'Null'}
    comment.save ? (render :json => hh, :status => :ok) : (render :json => fail, :status => :service_unavailable)
  end


  def remove_comment
    user = User.where(:auth_token => params[:auth_token]).first
    if user.blank?
      render :json => {'Error!' => "You're not logged in."}, :status => :forbidden
      return
    end
    comment = Comment.where(:id => params[:comment_id]).first
    if comment.user_id != user.id
      render :json =>{'Error!' => "This post isn't yours"}, :status => :forbidden
      return
    end
    if comment.blank?
      render :json => {'comment_id' => 'Null'}, :status => :not_found
      return
    end
    hh = {'post_id' => comment.post_id, 'text' => comment.text, 'likes' => comment.likes, 'date' => comment.created_at.to_s, 'comment_id' => comment.id, 'username' => User.find(comment.user_id).username}
    fail = {'Error!' => 'Null'}
    comment.destroy ? (render :json => hh, :status => :ok) : (render :json => fail, :status => :service_unavailable)
  end


  def like
    user = User.where(:auth_token => params[:auth_token]).first
    if user.blank?
      render :json => {'Error!' => "You're not logged in."}, :status => :forbidden
      return
    end
    comment = Comment.where(:id => params[:comment_id]).first
    if comment.user_id != user.id
      render :json =>{'Error!' => "This post isn't yours"}, :status => :forbidden
      return
    end

    if comment.blank?
      render :json => {'Error!' => 'Null'}, :status => :not_found
      return
    end
    comment.likes = comment.likes + 1
    hh = {'post_id' => comment.post_id, 'text' => comment.text, 'likes' => comment.likes, 'date' => comment.created_at.to_s, 'comment_id' => comment.id, 'username' => User.find(comment.user_id).username}
    fail = {'comment_id' => 'Null'}

    comment.save ? (render :json => hh, :status => :ok) : (render :json => fail, :status => :service_unavailable)
  end
end

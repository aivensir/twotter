class CommentsController < ApplicationController
  def return_comments
    render :json => {"text" => "hello_comments"}
  end

  def create_new_comment
    fail = {"comment_text" => "Null"}
    if params[:text].blank?
      render :json => fail, :status => :forbidden
      return
    end

    a = Post.find(params[:post_id])
    comment = a.comments.create(text: params[:text])
    hh = {"post_id" => comment.post_id, "text" => comment.text, "likes" => comment.likes, "date" => comment.created_at.to_s, "comment_id" => comment.id}
    render :json => hh, :status => :created
  end

  def edit_comment
    fail = {"comment_text" => "Null"}
    if params[:text].blank?
      render :json => fail, :status => :forbidden
      return
    end

    comment = Comment.find(params[:comment_id])
    if comment.blank?
      render :json => {"comment_id" => "Null"}, :status => :not_found
      return
    end
    comment.text = params[:text]

    hh = {"post_id" => comment.post_id, "text" => comment.text, "likes" => comment.likes, "date" => comment.updated_at.to_s, "comment_id" => comment.id }
    fail = {"comment_id" => "Null"}
    comment.save ? (render :json => hh, :status => :ok) : (render :json => fail, :status => :service_unavailable)
  end

  def remove_comment
    comment = Comment.find(params[:comment_id])
    if comment.blank?
      render :json => {"comment_id" => "Null"}, :status => :not_found
      return
    end
    hh = {"post_id" => comment.post_id, "text" => comment.text, "likes" => comment.likes, "date" => comment.created_at.to_s, "comment_id" => comment.id}
    fail = {"comment_id" => "Null"}
    comment.destroy ? (render :json => hh, :status => :ok) : (render :json => fail, :status => :service_unavailable)
  end

  def like
    comment = Comment.find(params[:comment_id])
    if comment.blank?
      render :json => {"comment_id" => "Null"}, :status => :not_found
      return
    end
    comment.likes = comment.likes + 1
    hh = {"post_id" => comment.post_id, "text" => comment.text, "likes" => comment.likes, "date" => comment.created_at.to_s, "comment_id" => comment.id }
    fail = {"comment_id" => "Null"}

    comment.save ? (render :json => hh, :status => :ok) : (render :json => fail, :status => :service_unavailable)
  end
end

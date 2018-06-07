class CommentsController < ApplicationController
  def return_comments
    render :json => {"text" => "hello_comments"}
  end

  def create_new_comment
    a = Post.where(:id => params[:post_id]).last
    comment = a.comments.create(text: params[:text])
    hh = {"post_id" => comment.post_id, "text" => comment.text, "likes" => comment.likes, "date" => comment.created_at.to_s, "comment_id" => comment.id}
    render :json => hh
  end

  def edit_comment
    comment = Comment.where(:id => params[:comment_id]).first
    if comment.blank?
      render :json => {"comment_id" => "Null"}
      return
    end
    comment.text = params[:text]
    hh = {"post_id" => comment.post_id, "text" => comment.text, "likes" => comment.likes, "date" => comment.created_at.to_s, "comment_id" => comment.id }
    fail = {"comment_id" => "Null"}
    comment.save ? (render :json => hh) : (render :json => fail)
  end

  def remove_comment
    comment = Comment.where(:id => params[:comment_id]).first
    if comment.blank?
      render :json => {"comment_id" => "Null"}
      return
    end
    hh = {"post_id" => comment.post_id, "text" => comment.text, "likes" => comment.likes, "date" => comment.created_at.to_s, "comment_id" => comment.id}
    fail = {"comment_id" => "Null"}
    comment.destroy ? (render :json => hh) : (render :json => fail)
  end

  def like
    comment = Comment.where(:id => params[:comment_id]).first
    if comment.blank?
      render :json => {"comment_id" => "Null"}
      return
    end
    comment.like = comment.like + 1
    hh = {"post_id" => comment.post_id, "text" => comment.text, "likes" => comment.likes, "date" => comment.created_at.to_s, "comment_id" => comment.id }
    fail = {"comment_id" => "Null"}
    comment.save ? (render :json => hh) : (render :json => fail)
  end
end

class PostsController < ApplicationController


  def return_posts
    a = Post.all.order(created_at: :desc)
    if a.blank?
      render :json => {"post_id" => "Null"}, :status => :not_found
      return                           
    end
    hh = {}
    a.each do |post|
      post_info_hash = {"post_id" => post.id, "text" => post.text, "likes" => post.likes, "date" => post.created_at.to_s}
      comments_hash = {}
      post.comments.each do |comment|
        comments_hash = comments_hash.merge({comment.id => {"comment_id" => comment.id, "text" => comment.text, "likes" => comment.likes, "date" => comment.created_at.to_s, "post_id" => post.id}})
      end
      hh = hh.merge({post.id => post_info_hash.merge({"comments" => comments_hash})})
    end
    render :json => hh, :status => :ok
  end

  def return_post
    post = Post.where(:id => params[:post_id]).first
    if post.blank?
      render :json => {"post_id" => "Null"}, :status => :not_found
      return
    end
    comments_hash = {}

    post.comments.each do |comment|
      comments_hash = comments_hash.merge({comment.id => {"comment_id" => comment.id, "text" => comment.text, "likes" => comment.likes, "date" => comment.created_at.to_s, "post_id" => post.id}})
    end

    render :json => {"post_id" => post.id, "text" => post.text, "likes" => post.likes, "date" => post.created_at.to_s}.merge({"comments" => comments_hash}), :status => :ok
   end

  def create_new_post #post
    fail = {"post_text" => "Null"}
    if params[:text].blank?
      render :json => fail, :status => :forbidden
      return
    end

    a = Post.new
    a.text = params['text']
    a.likes = 0
    a.save!

    hh = {"post_id" => a.id, "text" => a.text, "likes" => a.likes, "date" => a.created_at.to_s}
    a.save ? (render :json => hh, :status => :created) : (render :json => fail, :status => :service_unavailable)
  end

  def edit_post
    fail = {"post_text" => "Null"}
    if params[:text].blank?
      render :json => fail, :status => :forbidden
      return
    end

    a = Post.where(:id => params[:post_id]).first
    if a.blank?
      render :json => {"post_id" => "Null"}, :status => :not_found
      return
    end

    a.text = params[:text]
    hh = {"post_id" => a.id, "text" => a.text, "likes" => a.likes, "date" => a.updated_at.to_s}
    fail = {"post_id" => "Null"}
    a.save ? (render :json => hh, :status => :ok) : (render :json => fail, :status => :ok )
  end

  def remove_post
    a = Post.where(:id => params[:post_id]).first
    if a.blank?
      render :json => {"post_id" => "Null"}, :status => :not_found
      return
    end
    hh = {"post_id" => a.id, "text" => a.text, "likes" => a.likes, "date" => a.created_at.to_s}
    fail = {"post_id" => "Null"}
    a.destroy ? (render :json => hh, :status => :ok) : (render :json => fail, :status => :not_found)
  end

  def like
    a = Post.where(:id => params[:post_id]).first
    if a.blank?
      render :json => {"post_id" => "Null"}, :status => :not_found
      return
    end
    a.likes = a.likes + 1
    hh = {"post_id" => a.id, "text" => a.text, "likes" => a.likes, "date" => a.created_at.to_s}
    fail = {"post_id" => "Null"}
    a.save ? (render :json => hh, :status => :ok) : (render :json => fail, :status => :service_unavailable)
  end

end

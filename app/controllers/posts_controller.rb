class PostsController < ApplicationController
  #У меня есть печеньки

  def return_posts
    a = Post.all.order(created_at: :desc)
    if a.blank?
      render :json => {"post_id" => "Null"}
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
    render :json => hh
  end

  def return_post
    post = Post.where(:id => params[:post_id]).first
    if post.blank?
      render :json => {"post_id" => "Null"}
      return
    end

    comments_hash = {}
    post.comments.each do |comment|
      comments_hash = comments_hash.merge({comment.id => {"comment_id" => comment.id, "text" => comment.text, "likes" => comment.likes, "date" => comment.created_at.to_s, "post_id" => post.id}})
    end

    render :json => {"post_id" => post.id, "text" => post.text, "likes" => post.likes, "date" => post.created_at.to_s}.merge({"comments" => comments_hash})
   end

  def create_new_post #post
    a = Post.new

    a.text = params['text']
    a.likes = 0
    a.save!

    hh = {"post_id" => a.id, "text" => a.text, "likes" => a.likes, "date" => a.created_at.to_s}
    fail = {"post_id" => "Null"}
    a.save ? (render :json => hh) : (render :json => fail)
  end

  def edit_post
    a = Post.where(:id => params[:post_id]).last
    if a.blank?
      render :json => {"post_id" => "Null"}
      return
    end
    a.text = params[:text]

    hh = {"post_id" => a.id, "text" => a.text, "likes" => a.likes, "date" => a.created_at.to_s}
    fail = {"post_id" => "Null"}
    a.save ? (render :json => hh) : (render :json => fail)
  end

  def remove_post
    a = Post.where(:id => params[:post_id]).last
    if a.blank?
      render :json => {"post_id" => "Null"}
      return
    end
    hh = {"post_id" => a.id, "text" => a.text, "likes" => a.likes, "date" => a.created_at.to_s}
    fail = {"post_id" => "Null"}
    a.destroy ? (render :json => hh) : (render :json => fail)
  end

  def like
    a = Post.where(:id => params[:post_id]).last
    if a.blank?
      render :json => {"post_id" => "Null"}
      return
    end
    a.likes = a.likes + 1
    hh = {"psot_id" => a.id, "text" => a.text, "likes" => a.likes, "date" => a.created_at.to_s}
    fail = {"post_id" => "Null"}
    a.save ? (render :json => hh) : (render :json => fail)
  end

end

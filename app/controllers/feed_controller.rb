class FeedController < ApplicationController

  include PostHelper
  include YoutubeVideoHelper
  include VineVideoHelper
  include InstagramVideoHelper
  include ActionView::Helpers::UrlHelper

  def index
    respond_to do |format|
      format.html do
        @posts = Post.sorted_posts(ENV["HASHTAG"], 10)
        @posts.each { |post| post.text = add_post_links post }
        render "index"
      end
      format.json do
        @posts = Post.get_new_posts(ENV["HASHTAG"], 10)
        render_json_posts @posts
      end
    end
  end

  def get_next_page
    @posts = Post.next_posts(params[:last_post_id], 10)
    render_json_posts @posts
  end

  def agenda
    respond_to do |format|
      format.html do
        if params[:lang] && params[:lang].downcase.casecmp("en") == 0
          return render "agenda-en"
        end

        render "agenda"
      end
    end
  end

  def location
    respond_to do |format|
      format.html do
        render "location"
      end
    end
  end

  private

  def render_json_posts(posts)
    if posts.nil? || posts.empty?
      render json: posts, status: :not_modified
    else
      posts.each { |post| post.text = add_post_links post }
      render json: posts
    end
  end

end

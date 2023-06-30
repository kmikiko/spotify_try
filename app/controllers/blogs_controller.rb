class BlogsController < ApplicationController
  require 'rspotify'
  RSpotify.authenticate(ENV['SPOTIFY_CLIENT_ID'], ENV['SPOTIFY_SECRET_ID'])

  before_action :set_blog, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, only: [:new, :edit, :update, :destroy]

  # GET /blogs or /blogs.json
  def index
    @blogs = Blog.all
    @rank_blogs = Blog.order(impressions_count: 'DESC').limit(5)   # ランキング
    @tracks = []
    
    @blogs.each do |blog|
      song = blog.song
      artist = blog.artist
  
      # begin
        tracks = RSpotify::Track.search("#{song} #{artist}")
        tracks.each do |track|
          url = track.preview_url
          @tracks << { blog: blog, url: url, track: track }
        end
      # rescue StandardError => e
      #   puts "Error occurred"
      # end
    end
  end



  # GET /blogs/1 or /blogs/1.json
  def show
    impressionist(@blog, nil, unique: [:ip_address])  # 閲覧数

    @tracks = []
    song = @blog.song
    artist = @blog.artist
      # begin
        tracks = RSpotify::Track.search("#{song} #{artist}")
        tracks.each do |track|
          url = track.preview_url
          @tracks << { blog: @blog, url: url, track: track }
        end
      # rescue StandardError => e
      #   puts "Error occurred"
      # end
    

  end

  # GET /blogs/new
  def new
    @blog = Blog.new
  end

  # GET /blogs/1/edit
  def edit
  end

  # POST /blogs or /blogs.json
  def create
    @blog = Blog.new(blog_params)

    respond_to do |format|
      if @blog.save
        format.html { redirect_to blog_url(@blog), notice: "Blog was successfully created." }
        format.json { render :show, status: :created, location: @blog }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @blog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /blogs/1 or /blogs/1.json
  def update
    respond_to do |format|
      if @blog.update(blog_params)
        format.html { redirect_to blog_url(@blog), notice: "Blog was successfully updated." }
        format.json { render :show, status: :ok, location: @blog }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @blog.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /blogs/1 or /blogs/1.json
  def destroy
    @blog.destroy

    respond_to do |format|
      format.html { redirect_to blogs_url, notice: "Blog was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_blog
      @blog = Blog.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def blog_params
      params.require(:blog).permit(:title, :content, :artist, :song)
    end
end

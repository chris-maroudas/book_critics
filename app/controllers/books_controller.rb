class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]

  autocomplete :book, :searchable_terms, :full => true

  # GET /books
  # GET /books.json
  def index
    @books = Book.all
    @popular_tags = ActsAsTaggableOn::Tag.most_used
  end

  # GET /books/1
  # GET /books/1.json
  def show
    @new_review = @book.reviews.new
    @related_books = @book.find_related_tags
    @like = Like.where(book_id: @book.id, user_id: current_user.id).first
    @like = @book.likes.new if @like.blank?
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
  end

  # POST /books
  # POST /books.json
  def create
    @book = Book.new(book_params)

    respond_to do |format|
      if @book.save
        format.html { redirect_to @book, notice: 'Book was successfully created.' }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/1
  # PATCH/PUT /books/1.json
  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to @book, notice: 'Book was successfully updated.' }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
    @book.destroy
    respond_to do |format|
      format.html { redirect_to books_url, notice: 'Book was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def tags
    @books = (params[:tag].blank? || params[:tag] == "all") ? Book.all : Book.tagged_with(params[:tag])
    render :index
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def book_params
      params.require(:book).permit(:title, :list_of_tags, :author_id)
    end
end

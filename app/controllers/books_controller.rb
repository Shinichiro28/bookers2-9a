class BooksController < ApplicationController
   before_action :authenticate_user!

   impressionist :actions => [:show]

  def show
    @book = Book.find(params[:id])
    impressionist(@book, nil, unique: [:session_hash.to_s])
    @newbook = Book.new
    @book_comment = BookComment.new
  end

  def index
    to = Time.current.at_end_of_day
    from = (to - 6.day).at_beginning_of_day
    @books = Book.all.sort {|a,b|
        b.favorites.where(created_at: from...to).size <=>
        a.favorites.where(created_at: from...to).size
    }
    @book = Book.new
    @user = current_user
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @user = current_user
      @books = Book.all
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
    if @book.user == current_user
      render "edit"
    else
      redirect_to books_path
    end
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
   if @book.destroy
      flash[:notice] = "Book was successfully destroyed." # データ（レコード）を削除
      redirect_to books_path  #投稿一覧画面へリダイレクト
   end
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end
end

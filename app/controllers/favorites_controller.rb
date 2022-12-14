class FavoritesController < ApplicationController
  before_action :book_params, only: [:create, :destroy]

  def create
    book = Book.find(params[:book_id])
    favorite = current_user.favorites.new(book_id: book.id)
    favorite.save
    #redirect_back(fallback_location: root_path)
  end

  def destroy
    book = Book.find(params[:book_id])
    favorite = current_user.favorites.find_by(book_id: book.id)
    favorite.destroy
    #redirect_back(fallback_location: root_path)
  end

  private

  def book_params
    @book = Book.find(params[:book_id])
  end

end

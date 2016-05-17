class CommentsController < ApplicationController
  before_action :authenticate_user!


  def create
    @pin = Pin.find(params[:pin_id])
    @comment = Comment.create(params[:comment].permit(:comment))
    @comment.user_id = current_user.id
    @comment.pin_id = @pin.id


      if @comment.save
        CommentMailer.new_comment(@comment).deliver_now
        redirect_to pin_path(@pin)

      else
         render 'new'

      end
    end


  def destroy
      @pin = Pin.find(params[:pin_id])
      @comment = @pin.comments.find(params[:id])
      @comment.destroy
      respond_to do |format|
          format.html { redirect_to pin_path(@pin) }
          format.js { render :layout => false }
      end

  end


  def edit
    @pin = Pin.find(params[:pin_id])
    @comment = @pin.comments.find(params[:id])

  end

  def update
    @pin = Pin.find(params[:pin_id])
    @comment = @pin.comments.find(params[:id])

    if @comment.update(params[:comment].permit(:comment))
      redirect_to pin_path(@pin)
    else
      render 'edit'
    end
  end
end

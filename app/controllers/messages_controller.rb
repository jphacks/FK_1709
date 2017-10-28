class MessagesController < ApplicationController
def create
  @message = Message.new(message_params)
  @message.user = current_user

  if @message.save!
      redirect_to chat_path(id: @message.chat_id.to_i)
  end

end

private
  def message_params
    params.require(:message).permit(:chat_id, :message_type, :text, :image)
  end

end

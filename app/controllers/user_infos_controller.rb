class UserInfosController < ApplicationController
  before_action :authenticate_user!
  before_action :load_user_infos, only: %i(index)
  before_action :load_user_info,  except: %i(index new create)
  def index; end

  def new
    @user_info = UserInfo.new
  end

  def edit; end

  def create
    @user_info = current_user.user_infos.new user_info_params
    if @user_info.save
      handle_success_response
    else
      handle_error_response
    end
  end

  def set_default
    if @user_info.set_as_default
      handle_success_response
    else
      flash[:error] = t("alert.error")
      redirect_to root_path
    end
  end

  def update
    if @user_info.update user_info_params
      handle_success_response
    else
      handle_error_response
    end
  end

  def destroy
    flash[:error] = t("alert.error") unless @user_info.destroy

    redirect_to address_user_path
  end

  def user_info_params
    params.require(:user_info)
          .permit :name, :phoneNum, :address
  end

  private

  def handle_success_response
    respond_to do |format|
      load_user_infos
      format.html{redirect_back(fallback_location: root_path)}
      turbo_stream.update("user_infos_list", @user_infos)
    end
  end

  def handle_error_response
    respond_to do |format|
      format.html{render :new}
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update("modal-form", partial: "form",
                              locals: {user_info: @user_info})
        ]
      end
    end
  end

  def load_user_info
    @user_info = UserInfo.find_by(id: params[:id])
    return if @user_info

    flash[:error] = t("alert.error")
    redirect_to root_path
  end

  def load_user_infos
    @user_infos = current_user.user_infos.default_info_list
    return if @user_infos

    flash[:error] = t("alert.error")
    redirect_to root_path
  end
end

class WatchlistsController < ApplicationController

  before_action :logged_in_user

  def create
    @company = Company.find_by(local_code: params[:local_code])
    current_user.watch(@company)
    respond_to do |format|
      format.html { redirect_to company_path(params[:local_code]) }
      # format.js
    end
  end

  def destroy
    @company = Company.find_by(local_code: params[:id])
    current_user.unwatch(@company)
    respond_to do |format|
      format.html { redirect_to company_path(params[:id]) }
      format.js 
    end
  end
end

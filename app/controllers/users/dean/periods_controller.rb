class Users::Dean::PeriodsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_dean!
  before_action :set_period, only: [ :show, :edit, :update, :destroy ]

  def index
    @periods = Period.all
  end

  def show
  end

  def new
    @period = Period.new
  end

  def create
    @period = Period.new(period_params)

    if @period.save
      redirect_to users_dean_periods_path, notice: "Period was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @period.update(period_params)
      redirect_to users_dean_periods_path, notice: "Period was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @period.destroy
    redirect_to users_dean_periods_path, notice: "Period was successfully deleted."
  end

  private

  def set_period
    @period = Period.find(params[:id])
  end

  def period_params
    params.require(:period).permit(:start_date, :end_date)
  end

  def ensure_dean!
    unless current_user.person.is_a?(Dean)
      redirect_to root_path, alert: "Access denied. Deans only."
    end
  end
end

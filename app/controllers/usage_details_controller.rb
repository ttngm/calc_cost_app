class UsageDetailsController < ApplicationController
  after_action :updateSum, only: [:update, :getRakuten]

  def index
    @usageDetails = UsageDetail.all;
  end

  def show
    @usageDetail = UsageDetail.find(params[:id])
    @usageAmounts = @usageDetail.usageAmounts
  end

  def new
    @usageDetail = UsageDetail.new
  end

  def create
    @usageDetail = UsageDetail.new(usage_detail_params)
    if @usageDetail.save
      redirect_to @usageDetail
    else
      render 'new'
    end
  end

  def update
    @usageDetail = UsageDetail.find(params[:id])
    @usageDetail.usageAmounts.create!(usage_amount_params)
    redirect_to @usageDetail
  end

  def destroy
    @usageDetail = UsageDetail.find(params[:id])
    @usageDetail.destroy
    redirect_to usage_details_url
  end

  def getRakuten
    @usageDetail = UsageDetail.find(params[:id])
    usage_details_service = UsageDetailsService.new
    usage_details_service.downloadCsv(@usageDetail.year, @usageDetail.month)
    usage_details_service.saveRakutenUsage(@usageDetail)
    redirect_to @usageDetail
  end

  def calculate
    @usageDetail = UsageDetail.find(params[:id])
    updateSum()
    redirect_to @usageDetail
  end

  private
    def usage_detail_params
      params.require(:usage_detail).permit(:year, :month, usage_amount_attributes:[:usageDate, :usageStore, :amount, :division])
    end

    def usage_amount_params
      params.require(:usage_detail).permit(:division, :usageDate, :usageStore, :amount )
    end

  protected
    def updateSum()
      # 金額計算
      usage_details_service = UsageDetailsService.new
      sum = usage_details_service.calculate(@usageDetail)
      # 計算結果で更新
      @usageDetail.update(sum: sum)
    end
end

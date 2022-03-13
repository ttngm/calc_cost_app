class UsageDetailsController < ApplicationController
  def index
    
    @usageDetail = UsageDetail.find_by(year: params[:year], month: params[:month]);
    # logger.debug('method:' + @usageDetail.usageAmounts[2].method.to_s)

    @usageAmounts = @usageDetail.usageAmounts;
  end

  def show
    
    @usageDetail = UsageDetail.find_by(year: params[:year], month: params[:month]);
    logger.debug('method:' + @usageDetail.usageAmounts[2].method.to_s)

    # @usageAmounts = @usageDetail.usageAmounts;
  end
end

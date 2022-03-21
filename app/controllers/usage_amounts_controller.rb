class UsageAmountsController < UsageDetailsController
    after_action :updateSum, only: [:destroy, :update]

    def create
        @usageAmount = UsageAmount.new(params[:usage_amount])
    end

    def update
        @usageAmount = UsageAmount.find(params[:id])
        @usageDetail = UsageDetail.find(@usageAmount.usage_detail_id)
        @usageAmount.update(usage_amount_params)
        redirect_to request.referer
    end

    def destroy
        @usageAmount = UsageAmount.find(params[:id]).destroy
        @usageDetail = UsageDetail.find(@usageAmount.usage_detail_id)
        @usageAmount.destroy
        redirect_to request.referer
    end

    private
    def usage_amount_params
        params.require(:usage_amount).permit(:usageDate, :usageStore, :amount, :division)
      end

end
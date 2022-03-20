class UsageAmountsController < ApplicationController

    def create
        @usageAmount = UsageAmount.new(params[:usage_amount])
    end

    def destroy
        UsageAmount.find(params[:id]).destroy
    
        redirect_to request.referer
    end

end
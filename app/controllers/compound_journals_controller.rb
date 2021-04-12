class CompoundJournalsController < ApplicationController
  before_action :set_compound_journal, only: :destroy
  before_action :logged_in_user, only: :destroy
  before_action :admin_and_accounting_user, only: :destroy 
  before_action :set_one_month, only: :destroy
  
  def destroy
    @compound_journal.destroy
    redirect_back(fallback_location: root_path)
  end
  
  private
    def set_compound_journal
      @compound_journal = CompoundJournal.find(params[:id])
    end
end

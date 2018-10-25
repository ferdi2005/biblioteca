class ApplicationController < ActionController::Base
  include SessioniHelper
  def qualcuno?
    if utente_corrente.nil?
      redirect_to login_path
      flash[:info] = "Eseguire il login per continuare"
    end
  end

  def admin?
    qualcuno?
    unless utente_corrente.admin?
      redirect_to root_path
      flash[:danger] = "L'utente non ha i diritti per eseguire questa azione."
    end
  end
end

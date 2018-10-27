class ApplicationController < ActionController::Base
  include SessioniHelper
  include PrestitiHelper
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
      flash[:danger] = "L'utente non ha i diritti per eseguire questa azione. E che sei il grande a casa tua?"
    end
  end

end

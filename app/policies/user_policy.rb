class UserPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.all
    end
  end

  def index?
    user.admin?
  end

  def edit?
    return update?
  end

  def update?
    user.admin?
  end

  def new?
    return create?
  end

  def create?
    user.admin?
  end
end

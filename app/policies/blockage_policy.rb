class BlockagePolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.all
    end
  end

  def active?
    true
  end

  def show?
    true
  end

  def new?
    return create?
  end

  def create?
    user.admin? || user.department == "Quality"
  end

  def edit?
    return update?
  end

  def update?
    user.admin? || user.department == "Quality"
  end
end

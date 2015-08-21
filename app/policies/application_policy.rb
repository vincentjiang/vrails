class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    user && (user.has_role? :admin)
  end

  def show?
    scope.where(:id => record.id).exists?
  end

  def create?
    user.has_role? :admin
  end

  def new?
    create?
  end

  def update?
    user && (user.has_role? :admin)
  end

  def edit?
    update?
  end

  def destroy?
    user && (user.has_role? :admin)
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope
    end

    def update?
      user.has_role? :admin
    end
  end
end

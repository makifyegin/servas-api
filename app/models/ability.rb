# frozen_string_literal: true

class Ability
  include CanCan::Ability
  def initialize(user_id)
    Role.where(user_id: user_id, role: "national_secretary").each do |role|
      can(%i[destroy update], Country, group_id: role.group_id)
      can(%i[destroy update create], Region, country: { group_id: role.group_id })
      can(%i[create], Role, role: "interviewer", region: { country: { group_id: role.group_id } })
    end

    # can(:create, Country) if Role.exists?(user_id: user_id, role: "si_admin")
    can(:create, Country) if Role.exists?(user_id: user_id, role: "si_admin")
end
end

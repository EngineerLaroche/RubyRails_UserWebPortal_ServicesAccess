#**************************************************************
# APPLICATION ENREGISTREMENT
#**************************************************************
class ApplicationRecord < ActiveRecord::Base

  self.abstract_class = true

  extend ActsAsFollower::FollowerLib
  extend ActsAsFollower::FollowScopes
end

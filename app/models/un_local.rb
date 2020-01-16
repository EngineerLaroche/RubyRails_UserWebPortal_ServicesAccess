class UnLocal < ApplicationRecord

	validates :nom, :uniqueness => true
    validates :nom, presence: true, length: { maximum: 50 }
    validates_presence_of :nom, :qte_places

    acts_as_follower
    acts_as_followable

    #**************************
    # Search
    #**************************
    def self.search(search)

      where("nom LIKE ?", "%#{search}%")
    end
end

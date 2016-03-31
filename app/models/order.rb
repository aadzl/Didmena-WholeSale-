class Order < ActiveRecord::Base

  validates :order_number, uniqueness: { case_sensitive: false }
  validates :order_number, presence: true
  validates :order_number, length: { maximum: 20 }, on: :create
  validates :order_number, format: { with: /\A[A-Z0-9]{1,20}\Z/, message: "only allows uppercase letters and digits"}

  belongs_to :representative, inverse_of: :orders
  validates :representative, presence: true

  # domain CURRENCY !!!
  belongs_to :domain, inverse_of: :orders
  # validates :domain, presence: true
  belongs_to :order_status

  has_many :purchases, inverse_of: :order, dependent: :destroy

  has_many :products, through: :purchases

  before_create :set_order_status

  private

  def set_order_status
    self.order_status_id = 1
  end


end
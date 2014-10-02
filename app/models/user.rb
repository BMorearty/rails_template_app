class User < ActiveRecord::Base
  authenticates_with_sorcery!

  attr_writer :old_password
  attr_accessor :resetting_password

  ROLES = %w( guest registered admin )

  before_validation         :assign_default_role, unless: :role

  validate                  :old_password_must_be_correct, if: :password, unless: :resetting_password, on: :update
  validates_confirmation_of :password, if: :password, unless: :old_password_incorrect?
  validates_presence_of     :password, on: :create
  validates_length_of       :password, minimum: 4, if: :password, unless: :old_password_incorrect?
  validates_presence_of     :email
  validates_uniqueness_of   :email
  validates_format_of       :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, if: :email_changed?
  validates_presence_of     :role
  validates_inclusion_of    :role, in: ROLES

  ROLES.each do |r|
    define_method "#{r}?" do
      role.to_s == r
    end
  end

  def has_password?(password)
    self.class.sorcery_config.encryption_provider.matches?(crypted_password, password, salt)
  end

private

  def assign_default_role
    self.role = if email.present?
                  'registered'
                else
                  'guest'
                end
  end

  def old_password_must_be_correct
    errors[:old_password] = 'is incorrect' unless has_password?(@old_password)
  end

  def old_password_incorrect?
    errors[:old_password].present?
  end
end

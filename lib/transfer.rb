require "pry"

class Transfer
  attr_accessor :sender, :receiver, :amount, :status

  @@pending = []

  def initialize(sender, receiver, amount)
    @sender = sender
    @receiver = receiver
    @amount = amount
    @status = "pending"
    @@pending << self
  end

  def valid?
    self.sender.valid? && self.receiver.valid? && self.sender.balance > self.amount
  end

  def execute_transaction
    if self.valid? && self.status == "pending"
      self.sender.balance -= self.amount
      self.receiver.balance += self.amount
      self.complete
    else
      self.status = "rejected"
      "Transaction rejected. Please check your account balance."
    end
  end

  def complete
    self.status = "complete"
    @@pending.delete(self)
    "Transaction executed successfully"
  end

  def reverse_transfer
    if self.status == "complete"
      self.receiver.balance -= self.amount
      self.sender.balance += self.amount
      @@pending << self
      self.status = "reversed"
    else
      "Cannot reverse a transaction that has not been executed"
    end
  end

end

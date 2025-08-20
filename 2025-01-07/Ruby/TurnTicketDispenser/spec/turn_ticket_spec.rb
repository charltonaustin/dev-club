require_relative '../turn_ticket'

describe TurnTicket do
  it "does something" do
    dispenser = TicketDispenser.new
    ticket = dispenser.get_turn_ticket
  end

  context "when there are two dispensers" do
    it "should be able to dispense tickets" do
      dispenser1 = TicketDispenser.new
      ticket1 = dispenser1.get_turn_ticket
      puts ticket1.turn_number

      dispenser2 = TicketDispenser.new
      ticket2 = dispenser2.get_turn_ticket
      puts ticket2.turn_number

      expect(ticket1).not_to eq(ticket2)
    end
  end
end

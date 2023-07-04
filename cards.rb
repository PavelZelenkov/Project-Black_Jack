class Cards
  attr_accessor :cards, :cards_hash

  def initialize
    @cards = []
  end

  def new_cards
    cards_hash = {
      '2+' => 2, '3+' => 3, '4+' => 4, '5+' => 5, '6+' => 6,
      '7+' => 7, '8+' => 8, '9+' => 9, '10+' => 10,
      'K+' => 10, 'Q+' => 10, 'J+' => 10, 'A+' => 1,

      '2<3' => 2, '3<3' => 3, '4<3' => 4, '5<3' => 5, '6<3' => 6,
      '7<3' => 7, '8<3' => 8, '9<3' => 9, '10<3' => 10,
      'K<3' => 10, 'Q<3' => 10, 'J<3' => 10, 'A<3' => 1,

      '2<>' => 2, '3<>' => 3, '4<>' => 4, '5<>' => 5, '6<>' => 6,
      '7<>' => 7, '8<>' => 8, '9<>' => 9, '10<>' => 10,
      'K<>' => 10, 'Q<>' => 10, 'J<>' => 10, 'A<>' => 1,

      '2^' => 2, '3^' => 3, '4^' => 4, '5^' => 5, '6^' => 6,
      '7^' => 7, '8^' => 8, '9^' => 9, '10^' => 10,
      'K^' => 10, 'Q^' => 10, 'J^' => 10, 'A^' => 1
    }

    @cards = cards_hash.to_a
  end

  def cards_shuffle
    self.cards = @cards.shuffle.reverse.shuffle.reverse.shuffle
  end

  def cards_distribution(gamer)
    gamer << @cards[-1]
    @cards.delete_at(-1)
    gamer << @cards[-1]
    @cards.delete_at(-1)
  end

  def add_card(gamer)
    gamer << @cards[-1]
    @cards.delete_at(-1)
  end
end

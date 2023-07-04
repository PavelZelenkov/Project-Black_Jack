require_relative 'cards'
require_relative 'player'

class Main
  attr_accessor :cards, :user, :diler, :user_balance, :diler_balance, :bank_balance

  def initialize
    @cards = []
    @user = []
    @diler = []
  end

  def start
    puts 'Добро пожаловать в интерактивную программу ' \
         '- карточная игра "Black Jack"'
    print 'Введите ваше имя: '
    name = gets.strip.capitalize
    puts "Приветствую #{name}"

    @user_balance = 100
    @diler_balance = 100
    @bank_balance = 0

    loop do
      enter_game
    end
  end

  def enter_game
    puts 'Нажмите Enter для начала игры'
    gets

    bank_balance_sheet
    puts 'Ставка 10$'
    puts "Баланс игрока #{@user_balance}$"
    puts "Баланс дилера #{@diler_balance}$"
    puts "Текущая ставка: #{@bank_balance}$"

    card_deck

    puts # для удобства чтения

    players

    distribution_of_cards_to_player
    distribution_of_cards_to_the_dealer

    user_move
  end

  def card_deck
    @cards = Cards.new
    @cards.new_cards
    @cards.cards_shuffle
  end

  def players
    @user = Player.new
    @diler = Player.new
  end

  def distribution_of_cards_to_player
    @cards.cards_distribution(@user.player_card)
    puts 'Карты игрока: '
    listing_card(@user.player_card)
    sum_card(@user)
    puts "Сумма игрока: #{@user.sum_card}"
    puts # для удобства чтения
  end

  def distribution_of_cards_to_the_dealer
    @cards.cards_distribution(@diler.player_card)
    puts 'Карты дилера: '
    dealer_cards
    sum_card(@diler)
    puts # для удобства чтения
  end

  def user_move
    puts 'Ход игрока'
    puts 'Введите 1, если хотите пропустить'
    puts 'Введите 2, если хотите добавить карту'
    puts 'Введите 3, если хотите открыть карты'
    menu = gets.strip

    case menu
    when '1'
      skip
    when '2'
      take_a_card
    when '3'
      open_maps
    end
  end

  def skip
    puts 'Игрок принял решение пропустить ход'
    diler_move
  end

  def take_a_card
    puts 'Игрок взял карту'
    add_a_card(@user.player_card)
    listing_card(@user.player_card)
    sum_card(@user)
    puts "Сумма игрока: #{@user.sum_card}"
    puts # для удобства чтения
    diler_move
  end

  def dealer_cards
    if @diler.player_card.length == 2
      puts '*; *;'
    elsif @diler.player_card.length == 3
      puts '*; *; *;'
    end
  end

  def diler_move
    puts 'Ход дилера'
    if @diler.sum_card.to_i < 17 && @diler.player_card.length == 2
      puts 'Дилер взял карту'
      add_a_card(@diler.player_card)
    else
      puts 'Дилер пропускает ход'
    end
    dealer_cards
    sum_card(@diler)
    user_move
  end

  def listing_card(player)
    player.each do |key, _value|
      print "#{key}; "
    end
    puts # для удобства чтения
  end

  def sum_card(player)
    sum_card = []
    player.player_card.each do |_key, value|
      sum_card << value
    end
    sum_card.select { |i| sum_card << 10 if i == 1 && (sum_card.sum.to_i + 10 < 22) }
    player.sum_card = sum_card.sum.to_i
  end

  def add_a_card(player)
    if player.length == 2
      @cards.add_card(player)
    else
      puts 'У вас превышено количество карт'
    end
  end

  def open_maps
    sum_card(@user)
    print 'Карты игрока: '
    listing_card(@user.player_card)
    puts "Сумма игрока: #{@user.sum_card}"
    print 'Карты дилера: '
    listing_card(@diler.player_card)
    sum_card(@diler)
    puts "Сумма дилера: #{@diler.sum_card}"
    puts # для удобства чтения
    scoring
    enter_game
  end

  def scoring
    draw
    diler_win
    player_win
  end

  def draw
    if @user.sum_card == @diler.sum_card
      puts 'Ничья'
      @user_balance += 10
      @diler_balance += 10
      @bank_balance -= 20
      enter_game
    # rubocop:disable Lint/DuplicateBranch
    elsif @user.sum_card.to_i > 21 && @diler.sum_card.to_i > 21
      # rubocop:enable Lint/DuplicateBranch
      puts 'Ничья'
      @user_balance += 10
      @diler_balance += 10
      @bank_balance -= 20
      enter_game
    end
  end

  # rubocop:disable Metrics/AbcSize
  def diler_win
    if (@user.sum_card.to_i && @diler.sum_card.to_i) < 22 && @user.sum_card.to_i < @diler.sum_card.to_i
      puts 'Победа дилера'
      @diler_balance += 20
      @bank_balance -= 20
      enter_game
    # rubocop:disable Lint/DuplicateBranch
    elsif @diler.sum_card.to_i < 22 && @user.sum_card.to_i > 21
      # rubocop:enable Lint/DuplicateBranch
      puts 'Победа дилера'
      @diler_balance += 20
      @bank_balance -= 20
      enter_game
    end
  end

  def player_win
    if (@user.sum_card.to_i && @diler.sum_card.to_i) < 22 && @user.sum_card.to_i > @diler.sum_card.to_i
      puts 'Победа игрока'
      @user_balance += 20
      @bank_balance -= 20
      enter_game
    # rubocop:disable Lint/DuplicateBranch
    elsif @user.sum_card.to_i < 22 && @diler.sum_card.to_i > 21
      # rubocop:enable Lint/DuplicateBranch
      puts 'Победа игрока'
      @user_balance += 20
      @bank_balance -= 20
      enter_game
    end
  end
  # rubocop:enable Metrics/AbcSize

  def bank_balance_sheet
    if @user_balance.zero?
      puts 'Ваш баланс меньше необходимой ставки, конец игры'
      exit
    else
      @user_balance -= 10
      @bank_balance += 10
    end

    if @diler_balance.zero?
      puts 'Баланс Диллера равен "0", конец игры'
      exit
    else
      @diler_balance -= 10
      @bank_balance += 10
    end
  end
end

main = Main.new
main.start

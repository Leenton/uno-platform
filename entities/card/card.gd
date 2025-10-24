class_name Card

enum Colour {
    RED,
    YELLOW,
    GREEN,
    BLUE,
    WILD
}

enum Number {
    ZERO,
    ONE,
    TWO,
    THREE,
    FOUR,
    FIVE,
    SIX,
    SEVEN,
    EIGHT,
    NINE,
    NONE
}

enum Effect {
    NONE,
    SKIP,
    REVERSE,
    DRAW_TWO,
    WILD_DRAW_FOUR
}

var number: Number
var colour: Colour
var effect: Effect

static func generate_deck() -> Array[Card]:
    var deck: Array[Card] = []

    return deck

    # for card_colour in [Colour.RED, Colour.YELLOW, Colour.GREEN, Colour.BLUE]:
    #     for card_number in [Number.ONE, Number.TWO, Number.THREE, Number.FOUR, Number.FIVE, Number.SIX, Number.SEVEN, Number.EIGHT, Number.NINE]:
    #         var card := Card.new()
    #         card.colour = card_colour
    #         card.number = card_number
    #         card.effect = Effect.NONE
    #         deck.append(card)

    #     for card_effect in [Effect.SKIP, Effect.REVERSE, Effect.DRAW_TWO]:
    #         var card := Card.new()
    #         card.colour = card_colour
    #         card.number = Number.WILD
    #         card.effect = card_effect
    #         deck.append(card)

    # for i in range(4):
    #     var wild_card := Card.new()
    #     wild_card.colour = Colour.WILD
    #     wild_card.number = Number.WILD
    #     wild_card.effect = Effect.NONE
    #     deck.append(wild_card)

    #     var wild_draw_four_card := Card.new()
    #     wild_draw_four_card.colour = Colour.WILD
    #     wild_draw_four_card.number = Number.WILD
    #     wild_draw_four_card.effect = Effect.WILD_DRAW_FOUR
    #     deck.append(wild_draw_four_card)

    # return deck
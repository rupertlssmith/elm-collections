module Traits exposing (..)


type GameState
    = State


{-| FireTrait defines how the game state is updated for any kind of shooting
event.
's' is the state implementation parameter,
'a' makes the trait extensible so that traits can be combined.
-}
type alias FireTrait s a =
    { a
        | fire : s -> GameState -> GameState
    }


type alias Gun a =
    { a
        | power : Float
        , turretSize : Int
    }


{-| A castle has a gun and a shield.
-}
type alias Castle =
    Gun { shield : Float }


{-| A zap monster has a gun and health and a special zapping power.
-}
type alias ZapMonster =
    Gun
        { health : Float
        , zapPower : Float
        }


type alias CastleTraits =
    FireTrait Castle {}


type alias ZapMonsterTraits =
    FireTrait ZapMonster {}


{-| How to update the game state when a gun is fired - only needs to be written once.
-}
fireGun : Gun a -> GameState -> GameState
fireGun _ state =
    state


{-| How to update the game state for any firing trait - only needs to be written once.
-}
updateForFiring : FireTrait s a -> s -> GameState -> GameState
updateForFiring fireTrait gameObject state =
    fireTrait.fire gameObject state



-- Example with castles and zap monsters both with normal guns.


castleTraits : CastleTraits
castleTraits =
    { fire = fireGun }


zapMonsterTraits : ZapMonsterTraits
zapMonsterTraits =
    { fire = fireGun }


castle : Castle
castle =
    { power = 100, turretSize = 5, shield = 100 }


zapMonster : ZapMonster
zapMonster =
    { power = 60, turretSize = 2, health = 100, zapPower = 20 }


gameState1 =
    updateForFiring castleTraits castle State


gameState2 =
    updateForFiring zapMonsterTraits zapMonster gameState1



-- Example with a zap monster upgraded to use its special zap ability.
-- A new fire implementation is written, but the existing update logic is
-- re-used as it was coded for the general trait.


fireZap : ZapMonster -> GameState -> GameState
fireZap _ state =
    state


zapMonsterTraits2 : ZapMonsterTraits
zapMonsterTraits2 =
    { fire = fireZap }


gameState3 =
    updateForFiring zapMonsterTraits2 zapMonster gameState2

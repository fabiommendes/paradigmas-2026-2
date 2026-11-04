module Main exposing (main)

{-| Ponto de entrada: liga as regras de `Game` à tela, seguindo a Arquitetura
Elm (modelo, mensagens, `update` e `view`).
-}

import Browser
import Game exposing (Card, Face(..), Game, Turn(..))
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Process
import Rng exposing (Seed)
import Task


{-| O JavaScript passa um número aleatório como semente (veja `src/main.js`).
-}
type alias Flags =
    Int


main : Program Flags Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }



-- MODELO


type alias Model =
    { game : Game
    , seed : Seed
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( newModel (Rng.seed flags), Cmd.none )


newModel : Seed -> Model
newModel seed =
    let
        ( game, nextSeed ) =
            Game.new seed
    in
    { game = game, seed = nextSeed }



-- ATUALIZAÇÃO


type Msg
    = CardClicked Int
    | MismatchTimeout
    | NewGameClicked


{-| Tempo, em milissegundos, que as duas cartas erradas ficam à mostra.
-}
mismatchDelay : Float
mismatchDelay =
    1000


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        CardClicked id ->
            let
                game =
                    Game.reveal id model.game
            in
            case ( model.game.turn, game.turn ) of
                -- A jogada acabou de errar: desvira as cartas daqui a pouco.
                ( OnePicked _, Mismatch _ _ ) ->
                    ( { model | game = game }
                    , Task.perform (\_ -> MismatchTimeout) (Process.sleep mismatchDelay)
                    )

                _ ->
                    ( { model | game = game }, Cmd.none )

        MismatchTimeout ->
            ( { model | game = Game.hideMismatch model.game }, Cmd.none )

        NewGameClicked ->
            ( newModel model.seed, Cmd.none )



-- VISUALIZAÇÃO


{-| HTML esperado (exemplo sem vitória):

```html
<main class="table">
  <ol class="board" aria-label="Tabuleiro">
    <li class="board__slot">
      <button type="button" class="card" aria-label="Carta 1">
        <span class="card__inner">
          <span class="card__back"></span>
          <span class="card__front">
            <img class="card__image" src="cards/ia/a1.webp" alt="">
          </span>
        </span>
      </button>
    </li>
  </ol>
  <button class="fab" type="button" aria-label="Novo jogo" title="Novo jogo"></button>
</main>
```

```html
<main class="table">
  <ol class="board" aria-label="Tabuleiro">
    <li class="board__slot">
      <button type="button" class="card card--up card--matched" disabled="" aria-label="Carta 1, par encontrado">
        <span class="card__inner">
          <span class="card__back"></span>
          <span class="card__front">
            <img class="card__image" src="cards/ia/a1.webp" alt="">
          </span>
        </span>
      </button>
    </li>
  </ol>
  <button class="fab" type="button" aria-label="Novo jogo" title="Novo jogo"></button>
  <div class="overlay">
    <dialog class="victory" open="" aria-labelledby="victory-title">
      <h2 id="victory-title" class="victory__title">Parabéns!</h2>
      <p class="victory__text">8 jogadas</p>
      <button class="button button--primary" type="button" autofocus="">Jogar de novo</button>
    </dialog>
  </div>
</main>
```

-}
view : Model -> Html Msg
view model =
    todo


{-| HTML esperado:

```html
<button class="fab" type="button" aria-label="Novo jogo" title="Novo jogo"></button>
```

-}
viewNewGameButton : Html Msg
viewNewGameButton =
    todo


{-| HTML esperado:

```html
<ol class="board" aria-label="Tabuleiro">
  <li class="board__slot">
    <button type="button" class="card" aria-label="Carta 1">
      <span class="card__inner">
        <span class="card__back"></span>
        <span class="card__front">
          <img class="card__image" src="cards/ia/a1.webp" alt="">
        </span>
      </span>
    </button>
  </li>
</ol>
```

-}
viewBoard : Game -> Html Msg
viewBoard game =
    todo


{-| HTML esperado:

```html
<li class="board__slot">
  <button type="button" class="card" aria-label="Carta 1">
    <span class="card__inner">
      <span class="card__back"></span>
      <span class="card__front">
        <img class="card__image" src="cards/ia/a1.webp" alt="">
      </span>
    </span>
  </button>
</li>
```

-}
viewCard : Turn -> Card -> Html Msg
viewCard turn card =
    todo


{-| Caminho da imagem da carta, como `cards/ia/a1.webp`.
-}
imagePath : Card -> String
imagePath card =
    Debug.todo "imagePath"


isMissed : Turn -> Card -> Bool
isMissed turn card =
    case turn of
        Mismatch a b ->
            card.id == a || card.id == b

        _ ->
            False


{-| HTML esperado:

```html
<div class="overlay">
  <dialog class="victory" open="" aria-labelledby="victory-title">
    <h2 id="victory-title" class="victory__title">Parabéns!</h2>
    <p class="victory__text">8 jogadas</p>
    <button class="button button--primary" type="button" autofocus="">Jogar de novo</button>
  </dialog>
</div>
```

-}
viewVictory : Game -> Html Msg
viewVictory game =
    todo


{-| HTML placeholder:

```html
<div>TODO</div>
```

-}
todo : Html msg
todo =
    div [] [ text "TODO" ]

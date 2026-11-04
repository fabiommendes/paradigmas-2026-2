module Game exposing
    ( Card
    , Face(..)
    , Game
    , Turn(..)
    , fromDeck
    , hideMismatch
    , isPair
    , isWon
    , new
    , reveal
    )

{-| As regras do jogo da memória, sem nenhuma parte visual.

Tudo aqui é função pura: recebe um jogo e devolve outro. Isso permite
testar as regras sem abrir o navegador (veja `tests/GameTest.elm`).

Cada carta pertence a um grupo (`'a'` a `'h'`) e é o membro 1 ou 2 dele.
No tema dos animais, o grupo é a espécie e o membro é o macho ou a fêmea.
A regra que diferencia este jogo do tradicional fica em `isPair`: duas
cartas formam par quando são do mesmo grupo e membros diferentes, e não
quando são iguais.

-}

import Rng exposing (Seed)


type alias Game = ()


{-| Assets de cada carta são identificados por um par (letra, numero), como 
"a1", "b2", etc 
-}
type alias Card = ()

type alias CardId = Int

type Face = Face


{-| Em que ponto da jogada estamos. -}
type Turn = Turn


{-| Embaralha as cartas e começa um jogo. Devolve também a semente seguinte,
para a próxima partida sair diferente.
-}
new : Seed -> ( Game, Seed )
new seed = Debug.todo "new"


{-| Inicializa o jogo a partir de uma lista de cartas
-}
fromDeck : List ( Char, Int ) -> Game
fromDeck deck = Debug.todo "fromDeck"


{-| Oito grupos com dois membros cada: as 16 cartas do tabuleiro 4 × 4. Ordenado
-}
fullDeck : List ( Char, Int )
fullDeck =
    List.concatMap (\group -> [ ( group, 1 ), ( group, 2 ) ]) (String.toList "abcdefgh")


{-| Constrói uma carta a partir de um id e um par (grupo, membro) -}
toCard : Int -> ( Char, Int ) -> Card
toCard id ( group, member ) = Debug.todo "toCard"


{-| Mesmo grupo, membros diferentes.
-}
isPair : Card -> Card -> Bool
isPair a b = Debug.todo "isPair"


{-| Vira a carta com este `id`. Cartas que já estão viradas são ignoradas.
-}
reveal : Int -> Game -> Game
reveal id game = Debug.todo "reveal"


{-| Processa a carta escolhida de acordo com o estado da jogada.
-}
pick : Card -> Game -> Game
pick card game = Debug.todo "pick"


{-| Desvira as duas cartas que não formaram par.
-}
hideMismatch : Game -> Game
hideMismatch game = Debug.todo "hideMismatch"


{-| Indica se todas as cartas já formam pares.
-}
isWon : Game -> Bool
isWon game = Debug.todo "isWon"


{-| Procura uma carta pelo identificador.
-}
findCard : Int -> Game -> Maybe Card
findCard id game = Debug.todo "findCard"


{-| Atualiza a face das cartas cujos identificadores foram informados.
-}
setFace : Face -> List Int -> List Card -> List Card
setFace face ids cards = Debug.todo "setFace"

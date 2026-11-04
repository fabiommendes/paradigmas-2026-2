# Laboratório: WebApp em Elm, parte 2 (chamadas de API)

Hoje o jogo da memória deixa de inventar as próprias cartas. Em vez de montar
`a1` a `h2` direto no código, ele vai pedir as cartas a um servidor web, pela
rede, usando `elm/http` e `elm/json`.

Ao final da aula, o jogo:

* busca as 16 cartas em `GET /api/cards` assim que abre;
* mostra "Carregando..." enquanto a resposta não chega;
* mostra uma mensagem clara quando algo dá errado;
* pede cartas novas ao servidor no botão de novo jogo.

| Etapa                          | Tempo  |
| :----------------------------- | -----: |
| 0. Conhecer a API              | 10 min |
| 1. Tipo e decoder              | 15 min |
| 2. Cartas vindas de fora (mock)| 15 min |
| 3. A requisição                | 10 min |
| 4. O estado da requisição      | 25 min |
| 5. Erros                       | 15 min |
| 6. Novo jogo                   | 10 min |

Terminou antes? Há três [extras](#extras) no fim.

---

## 0. Conhecer a API (10 min)

Em dois terminais, na pasta do projeto:

```sh
pnpm install    # só na primeira vez
pnpm api        # terminal 1: API em http://localhost:8000
pnpm dev        # terminal 2: jogo em http://localhost:5173
```

O `pnpm api` usa o [uv](https://docs.astral.sh/uv/) para rodar um servidor
FastAPI em `server/main.py`. Na primeira vez, ele instala o FastAPI sozinho.

Abra **http://localhost:8000/docs**. Esta é a documentação interativa da
API (Swagger). Em cada rota, clique em **Try it out** e depois em
**Execute**.

1. `GET /api/themes`: lista os temas. Anote os `id`s: `animals`, `pokemon` e
   `simpsons`.
2. `GET /api/cards` com `theme = animals` e `equalPairs = false`.
3. Repita com `equalPairs = true`. O que mudou nas cartas?
4. Repita com `theme = pokemon` e depois `theme = simpsons`.
5. Tente `theme = nao-existe`. Qual é o código de resposta?

Uma resposta de `/api/cards` tem esta cara:

```json
[
  { "group": "a", "description": "pavão (macho)", "url": "/cards/animals/a1.webp" },
  { "group": "a", "description": "pavão (fêmea)", "url": "/cards/animals/a2.webp" },
  { "group": "b", "description": "leão (macho)",  "url": "/cards/animals/b1.webp" }
]
```

Repare:

* São 16 cartas, duas por grupo, **sem embaralhar**. Embaralhar continua
  sendo trabalho do Elm (`Rng.shuffle`).
* `url` pode ser um caminho do nosso servidor (`/cards/...`) ou uma URL
  externa (Pokémon e Simpsons).
* `group` é uma **string** de uma letra. No Elm queremos um `Char`.
* `equalPairs = true` manda a mesma carta duas vezes em cada grupo (jogo da
  memória tradicional).

O jogo roda na porta 5173 e a API na 8000. O Vite repassa para a API tudo o
que começa com `/api` e `/cards` (veja `vite.config.js`). Por isso, no Elm,
basta usar caminhos como `/api/cards`, sem `http://localhost:8000`.

---

## 1. Tipo e decoder (15 min)

**Objetivo:** transformar o JSON de uma carta num valor Elm.

Crie o arquivo `src/Api.elm`:

```elm
module Api exposing (CardInfo, getCards)

import Http
import Json.Decode as D exposing (Decoder)
import Url.Builder


{-| Uma carta como vem da API, antes de entrar no jogo.
-}
type alias CardInfo =
    { group : Char
    , description : String
    , url : String
    }


cardDecoder : Decoder CardInfo
cardDecoder =
    D.map3 CardInfo
        (D.field "group" charDecoder)
        -- TODO: os campos "description" e "url"
```

Não existe `D.char`. Escreva um `charDecoder` que lê uma string e só aceita
quando ela tem exatamente uma letra. Use `D.andThen`, que decide o próximo
passo olhando o valor já lido:

```elm
charDecoder : Decoder Char
charDecoder =
    D.string
        |> D.andThen
            (\s ->
                case String.toList s of
                    [ c ] ->
                        D.succeed c

                    _ ->
                        D.fail ("esperava uma letra, veio " ++ s)
            )
```

**Deu certo?** Por enquanto, exponha também `cardDecoder` no `module Api
exposing (...)` e teste no `elm repl`:

```elm
> import Api
> import Json.Decode as D
> D.decodeString Api.cardDecoder """{"group":"a","description":"leão","url":"x.webp"}"""
Ok { url = "x.webp", group = 'a', description = "leão" }
> D.decodeString Api.cardDecoder """{"group":"ab","description":"leão","url":"x.webp"}"""
Err (Field "group" (Failure ("esperava uma letra, veio ab") <internals>))
```

Teste também um JSON sem o campo `url`. Que erro aparece?

**Saiba mais:** [`Json.Decode`](https://package.elm-lang.org/packages/elm/json/latest/Json-Decode) · [`D.map3`](https://package.elm-lang.org/packages/elm/json/latest/Json-Decode#map3) · [`D.andThen`](https://package.elm-lang.org/packages/elm/json/latest/Json-Decode#andThen) · [guia: JSON](https://guide.elm-lang.org/effects/json.html)

---

## 2. Cartas vindas de fora (15 min)

**Objetivo:** fazer o `Game` receber as cartas prontas, em vez de criá-las.
Ainda sem rede: as cartas vêm de uma lista fixa (um *mock*) no `Main`.

Hoje, `Game.new` monta as cartas `a1` a `h2` sozinho, e `Main.cardUrl`
adivinha o nome do arquivo de imagem. Os dois vão sair.

### Em `src/Game.elm`

Troque o campo `index` de `Card` pelos dados que vêm da API:

```elm
type alias Card =
    { id : CardId
    , group : Char
    , description : String
    , url : String
    , face : Face
    }
```

Mude `new` para receber a lista de cartas:

```elm
import Api exposing (CardInfo)

new : Seed -> List CardInfo -> ( Game, Seed )
new seed infos =
    let
        ( cards, newSeed ) =
            infos
                |> List.indexedMap
                    (\id info ->
                        -- TODO: monte o Card a partir de id e info,
                        -- com face = Down
                    )
                |> Rng.shuffle seed
    in
    ( { cards = cards, turn = Waiting }, newSeed )
```

### Em `src/Main.elm`

Crie a lista fixa. Ela faz o mesmo que o `Game.new` antigo, mas agora mora
fora do `Game`:

```elm
mockCards : List CardInfo
mockCards =
    [ 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h' ]
        |> List.concatMap (\g -> [ mockCard g 1, mockCard g 2 ])


mockCard : Char -> Int -> CardInfo
mockCard group index =
    { group = group
    , description = "carta de teste"
    , url = "/cards/animals/" ++ String.fromChar group ++ String.fromInt index ++ ".webp"
    }
```

Depois:

* use `Game.new seed mockCards` nos dois lugares que chamavam `Game.new`;
* na `viewCard`, troque `src (cardUrl card)` por `src card.url` e
  `alt ""` por `alt card.description`;
* apague a função `cardUrl`.

**Deu certo?** O jogo funciona exatamente como antes. O compilador vai
apontar cada lugar que ainda usa `index` ou `cardUrl`: siga as mensagens.

**Saiba mais:** [`List.indexedMap`](https://package.elm-lang.org/packages/elm/core/latest/List#indexedMap) · [`List.concatMap`](https://package.elm-lang.org/packages/elm/core/latest/List#concatMap) · [guia: registros](https://guide.elm-lang.org/core_language.html#records)

---

## 3. A requisição (10 min)

**Objetivo:** escrever a função que pede as cartas ao servidor.

Em `src/Api.elm`:

```elm
getCards : String -> Bool -> (Result Http.Error (List CardInfo) -> msg) -> Cmd msg
getCards theme equalPairs toMsg =
    Http.get
        { url =
            Url.Builder.absolute [ "api", "cards" ]
                [ Url.Builder.string "theme" theme
                , Url.Builder.string "equalPairs" (boolToString equalPairs)
                ]
        , expect = Http.expectJson toMsg (D.list cardDecoder)
        }
```

Escreva `boolToString : Bool -> String`, que devolve `"true"` ou `"false"`.

Leia a assinatura com calma:

* `Url.Builder` monta `/api/cards?theme=animals&equalPairs=false` e cuida
  dos caracteres especiais.
* `Http.get` **não faz** a requisição. Ele devolve um `Cmd msg`, uma
  descrição do que deve ser feito. Quem executa é o runtime do Elm.
* Quando a resposta chega, o runtime passa o resultado por `toMsg` e entrega
  a mensagem ao `update`. O resultado é um `Result`: ou a lista de cartas, ou
  um `Http.Error`.

**Deu certo?** Compila. Ainda não muda nada na tela.

**Saiba mais:** [`Http.get`](https://package.elm-lang.org/packages/elm/http/latest/Http#get) · [`Http.expectJson`](https://package.elm-lang.org/packages/elm/http/latest/Http#expectJson) · [`Url.Builder`](https://package.elm-lang.org/packages/elm/url/latest/Url-Builder) · [`Cmd`](https://package.elm-lang.org/packages/elm/core/latest/Platform-Cmd) · [guia: HTTP](https://guide.elm-lang.org/effects/http.html)

---

## 4. O estado da requisição (25 min)

**Objetivo:** abrir o jogo com cartas vindas do servidor.

Uma requisição passa por três momentos: ainda não respondeu, falhou ou deu
certo. Um tipo soma deixa isso explícito e impede estados sem sentido, como
"jogando e com erro ao mesmo tempo".

Em `src/Main.elm`, troque o modelo:

```elm
import Http

type alias Model =
    { seed : Seed
    , state : State
    }


type State
    = Loading
    | Failed Http.Error
    | Playing Game
```

O `init` agora começa carregando e **devolve um comando**:

```elm
init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { seed = Rng.seed flags, state = Loading }, fetchCards )


fetchCards : Cmd Msg
fetchCards =
    Api.getCards "animals" False GotCards
```

Acrescente a mensagem que traz a resposta:

```elm
type Msg
    = CardClicked Int
    | MismatchTimeout
    | NewGameClicked
    | GotCards (Result Http.Error (List CardInfo))
```

No `update`, trate os dois casos do `Result`:

```elm
        GotCards (Ok infos) ->
            let
                ( game, nextSeed ) =
                    Game.new model.seed infos
            in
            -- TODO: guarde a semente nova e vá para Playing game

        GotCards (Err err) ->
            -- TODO: vá para Failed err
```

`CardClicked` só faz sentido durante o jogo:

```elm
        CardClicked id ->
            case model.state of
                Playing game ->
                    ( { model | state = Playing (Game.reveal id game) }, Cmd.none )

                _ ->
                    ( model, Cmd.none )
```

Na `view`, escolha o que mostrar no lugar do tabuleiro conforme o estado.
O CSS já tem a classe `status` para as mensagens:

```elm
view model =
    main_
        [ class "table" ]
        [ case model.state of
            Loading ->
                p [ class "status" ] [ text "Carregando as cartas..." ]

            Failed err ->
                p [ class "status status--error" ] [ text "Algo deu errado." ]

            Playing game ->
                -- TODO: o ol com o tabuleiro, como antes
        , viewNewGameButton
        ]
```

Por fim, apague `mockCards` e `mockCard`.

**Deu certo?**

* O jogo abre com as cartas do servidor.
* No depurador do Elm (canto da tela), aparece a mensagem `GotCards (Ok ...)`.
  Abra e veja as 16 cartas que chegaram.
* Troque `"animals"` por `"pokemon"` e por `"simpsons"` em `fetchCards`.
* Para ver o "Carregando...", acrescente
  `Url.Builder.int "delay" 2000` na lista de parâmetros de `getCards`. O
  servidor espera 2 segundos antes de responder. Depois, tire.

**Saiba mais:** [`Browser.element`](https://package.elm-lang.org/packages/elm/browser/latest/Browser#element) · [`Cmd.none`](https://package.elm-lang.org/packages/elm/core/latest/Platform-Cmd#none) · [guia: tipos customizados](https://guide.elm-lang.org/types/custom_types.html) · [guia: pattern matching](https://guide.elm-lang.org/types/pattern_matching.html)

---

## 5. Erros (15 min)

**Objetivo:** dizer ao jogador o que aconteceu.

`Http.Error` é um tipo soma com cinco casos. Escreva:

```elm
errorToString : Http.Error -> String
errorToString err =
    case err of
        Http.BadUrl url ->
            "URL inválida: " ++ url

        Http.Timeout ->
            "O servidor demorou demais para responder."

        Http.NetworkError ->
            -- TODO

        Http.BadStatus status ->
            -- TODO: use String.fromInt status

        Http.BadBody message ->
            -- TODO
```

Use `errorToString err` no caso `Failed err` da `view`.

**Deu certo?** Provoque cada erro, confira a mensagem e desfaça a mudança:

| Como provocar                                         | Erro esperado    |
| :---------------------------------------------------- | :--------------- |
| pare a API (Ctrl+C no terminal dela) e recarregue     | `NetworkError`   |
| peça o tema `"nao-existe"` em `fetchCards`            | `BadStatus 404`  |
| faça `boolToString` devolver `"talvez"`               | `BadStatus 422`  |
| troque `"group"` por `"grupo"` no `cardDecoder`       | `BadBody ...`    |

Repare que o compilador obriga a tratar todos os casos de `Http.Error`. Não
há como esquecer o caso "sem rede".

Desafio rápido: mostre "Tema não encontrado." só para o 404. Dica: um
`case` aceita o padrão `Http.BadStatus 404` antes de `Http.BadStatus status`.

**Saiba mais:** [`Http.Error`](https://package.elm-lang.org/packages/elm/http/latest/Http#Error) · [`Result`](https://package.elm-lang.org/packages/elm/core/latest/Result) · [guia: Result](https://guide.elm-lang.org/error_handling/result.html)

---

## 6. Novo jogo (10 min)

**Objetivo:** cada partida nova pede cartas novas ao servidor.

No `update`, o `NewGameClicked` volta para `Loading` e dispara
`fetchCards`:

```elm
        NewGameClicked ->
            ( { model | state = Loading }, fetchCards )
```

**Deu certo?** Com `equalPairs = True` em `fetchCards`, cada partida
pode trazer cartas diferentes. Com `"simpsons"`, o servidor sorteia 8 dos 9
personagens a cada pedido.

**Saiba mais:** [`Cmd`](https://package.elm-lang.org/packages/elm/core/latest/Platform-Cmd) · [`Http.get`](https://package.elm-lang.org/packages/elm/http/latest/Http#get)

---

## Extras

Em ordem de dificuldade. O último é para casa ou para quem já está voando.

### A. Pares iguais

Coloque `equalPairs : Bool` no `Model` e uma caixa de seleção na tela:

```elm
input [ type_ "checkbox", checked model.equalPairs, onCheck EqualPairsToggled ] []
```

Ao marcar ou desmarcar, comece um jogo novo com o valor escolhido.
`fetchCards` passa a receber o modelo: `fetchCards : Model -> Cmd Msg`.

Pergunta: com pares iguais, as duas cartas do par têm o mesmo `group`, a
mesma `url` e a mesma `description`. Como o `Game` sabe que você não clicou
duas vezes na mesma carta?

**Saiba mais:** [`Html.Events.onCheck`](https://package.elm-lang.org/packages/elm/html/latest/Html-Events#onCheck) · [`Html.Attributes.checked`](https://package.elm-lang.org/packages/elm/html/latest/Html-Attributes#checked)

### B. Escolha de tema

1. Em `Api.elm`, crie `type alias Theme = { id : String, name : String }`,
   o decoder e `getThemes`, que chama `GET /api/themes`.
2. No `init`, faça as duas requisições ao mesmo tempo com
   `Cmd.batch [ Api.getThemes GotThemes, fetchCards model ]`.
3. Guarde `themes : List Theme` e `theme : String` no modelo.
4. Mostre um `select` com um `option` por tema. Use `onInput ThemeSelected`:
   o valor recebido é o `value` do `option` escolhido, ou seja, o `id`.
5. Ao trocar de tema, comece um jogo novo.

**Saiba mais:** [`Cmd.batch`](https://package.elm-lang.org/packages/elm/core/latest/Platform-Cmd#batch) · [`Html.select`](https://package.elm-lang.org/packages/elm/html/latest/Html#select) · [`Html.Events.onInput`](https://package.elm-lang.org/packages/elm/html/latest/Html-Events#onInput) · [`Html.Attributes.selected`](https://package.elm-lang.org/packages/elm/html/latest/Html-Attributes#selected)

### C. Desvirar o par errado sozinho

Hoje, um par errado fica à mostra até o próximo clique. Faça as duas cartas
desvirarem sozinhas depois de `mismatchDelay` (1 segundo).

1. Implemente `Game.hideMismatch : Game -> Game`. Se o `turn` for
   `TwoRevealed`, desvire as duas cartas e volte para `Waiting`. Senão,
   devolva o jogo sem mudanças.
2. No `CardClicked`, depois do `Game.reveal`, se o `turn` virou
   `TwoRevealed`, devolva um comando que espera e depois manda
   `MismatchTimeout`:

   ```elm
   Process.sleep mismatchDelay
       |> Task.perform (\_ -> MismatchTimeout)
   ```

   `Process.sleep` devolve uma `Task` (um efeito que ainda vai acontecer).
   `Task.perform` a transforma num `Cmd`, como o `Http.get`.
3. No `update`, trate `MismatchTimeout` chamando `Game.hideMismatch`.

Cuidado com uma armadilha: o jogador pode clicar numa terceira carta antes
de o segundo passar, errar de novo, e o timer **antigo** desvirar o par
**novo** antes da hora. Uma solução é levar o estado junto na mensagem,
`MismatchTimeout Turn`, e só desvirar se `game.turn` ainda for igual a ele.

**Saiba mais:** [`Process.sleep`](https://package.elm-lang.org/packages/elm/core/latest/Process#sleep) · [`Task.perform`](https://package.elm-lang.org/packages/elm/core/latest/Task#perform) · [`Task`](https://package.elm-lang.org/packages/elm/core/latest/Task)

---

## Resumo

* `Http.get` devolve um `Cmd`. O Elm faz a requisição e devolve o resultado
  como uma mensagem para o `update`.
* Um `Decoder` descreve como transformar JSON num valor Elm. Com
  `D.andThen`, o decoder também valida o que lê.
* A resposta é um `Result Http.Error a`: o compilador obriga a tratar a
  falha.
* Um tipo soma (`Loading | Failed | Playing`) deixa a tela coerente com o
  estado da requisição.

**Saiba mais:** [`elm/http`](https://package.elm-lang.org/packages/elm/http/latest/Http) · [`elm/json`](https://package.elm-lang.org/packages/elm/json/latest/Json-Decode) · [guia: efeitos: HTTP e JSON](https://guide.elm-lang.org/effects/)

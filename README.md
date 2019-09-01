Este README tem objetivo de apresentar brevemente as decisões tomadas durante o desenvolvimento do projeto.

Qualquer dúvida, é só me perguntar :) 
victorsmelo@outlook.com

# View Code
Decidi usar View Code pois prefiro, já que o compilador nos protege, garantindo coisas que, se usasse storyboard ou até xib, não seriam garantidas pelo compilador.

# Testes Unitários
Foram criados testes unitários para o modelo (ModelTests), para o algoritmo de shuffle (CustomShuffleTests), para as células da view (SongTableViewCellTests) e para a viewModel (ShuffleListViewModelTests).

Foi usado um stub para mockar o response da API (lookupResponse.json) e foi criado um mock pro SongsService (SongsServiceMock), garantindo que os testes não dependam da API.

# Arquitetura

Escolhi MVVM, pois é uma arquitetura simples e que força a separação de certas responsabilidades, como fazer requests, removendo-as da ViewController. Acredito que podemos ter essa separação com MVC, mas MVVM força ela, garantindo a separação à médio e longo prazo.

Pensei sobre coordinators (MVVM-C), mas como o projeto não possui fluxo de telas, decidi deixar de fora. Futuramente poderia ser uma opção se houvesse tal fluxo.

## ShufleListViewController
Responsável pela UI e interação dos usuários.

## ShuffleListViewModel
Responsável por chamar o service, fazendo requests, além de converter modelo (cell Song) em objetos que irão pra View (struct CellData).

A lista do ID de artistas e o SongService são injetados na ViewModel, assim sendo mais fácil de testá-la futuramente.

## CellData
Estrutura de title, subtitle e image que será consumida pela ViewController para popular as células. Usando essa estrutura, não precisamos passar o modelo Song inteiro pra ViewController.

## ViewState
É um enum que possui estados da view. Usando este enum, podemos facilmente ajustar a view de acordo com o estado, que é setado pela ViewModel. Os estados são: empty, error, loading e showing.

## SongsService e SongsAPIService
Criei o protocolo SongsService, separando a definição da implementação SongsAPIService, para poder mockar o service nos testes unitários (SongsServiceMock).

## APIService
Apenas encapsulei o comportamento de request e coisas relacionadas à API nesta classe, pois acredito que saber destes detalhes (criar URLSession, lidar com response dela, etc) não devam ser responsabilidade do SongsAPIService. Assim, futuramente, seria mais fácil trocar a maneira que o SongsAPIService faz request.

## CustomShuffle
Este algoritmo de shuffle possui alguns estados que devem ser tratados durante sua execução. Como ele ficou um pouco extenso, coloquei dentro de uma classe própria, tirando essa responsabilidade da ShuffleListViewModel, que usa ele.

Este algoritmo possui basicamente duas etapas:
1. Dá um shuffle na lista de músicas (não garantindo que músicas do mesmo artista fiquem separadas).
2. Usa uma estrutura de fila de prioridade para, a partir da lista gerada na primeira etapa, ir adicionando músicas. Ao priorizar adicionar o artista que possui mais música ainda não adicionada garante-se que, se for possível, não haverão músicas do mesmo artista uma após a outra.

Esse algoritmo pode ser simplificado, usando estruturas mais simples para controlar seus estados. Não foi feito isso por questão de tempo de desenvolvimento (preciso terminar isso hoje pois durante a semana, com trabalho e faculdade, não terei tanto tempo). Tentei documentá-lo o melhor possível usando comentários.

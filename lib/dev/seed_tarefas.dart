import 'package:zetesis/model/pergunta.dart';
import 'package:zetesis/model/resposta.dart';
import 'package:zetesis/model/tarefa.dart';

abstract final class SeedTarefas {
  static const tarefas = [
    TarefaModel(
      nome: 'Fundamentos da Existência',
      tema: 'Existência',
      descricao: 'Do cogito de Descartes ao existencialismo de Sartre.',
      enviadoPor: 'Prof. Exemplo',
      dataEnvio: '01/01/2025',
      perguntas: [
        PerguntaModel(
          enunciado: 'Quem é o autor da frase "Penso, logo existo"?',
          explicacao:
              'Descartes formulou o "Penso, logo existo" como a primeira '
              'certeza inabalável: posso duvidar de tudo, menos de que estou '
              'pensando — e, portanto, de que existo.',
          respostas: [
            RespostaModel(texto: 'René Descartes', isCorrect: true),
            RespostaModel(texto: 'Platão'),
            RespostaModel(texto: 'Immanuel Kant'),
            RespostaModel(texto: 'Friedrich Nietzsche'),
          ],
        ),
        PerguntaModel(
          enunciado:
              'Para Sartre, o que significa dizer que "a existência precede a essência"?',
          explicacao:
              'Para Sartre não há uma natureza humana pré-definida: o ser '
              'humano primeiro existe e só depois se define por meio de suas '
              'escolhas e ações.',
          respostas: [
            RespostaModel(
              texto: 'Primeiro existimos e depois nos definimos pelas escolhas',
              isCorrect: true,
            ),
            RespostaModel(
              texto: 'Nossa essência é definida antes do nascimento',
            ),
            RespostaModel(texto: 'A essência humana é imutável'),
            RespostaModel(texto: 'Existir é apenas uma ilusão dos sentidos'),
          ],
        ),
        PerguntaModel(
          tipo: TipoPergunta.vf,
          enunciado:
              'Para os existencialistas, o ser humano nasce com um propósito '
              'pré-definido que cabe a ele descobrir.',
          explicacao:
              'É o contrário: para o existencialismo não há propósito dado de '
              'antemão — cada um constrói o sentido da própria vida através '
              'de suas escolhas.',
          respostas: [
            RespostaModel(texto: 'Verdadeiro'),
            RespostaModel(texto: 'Falso', isCorrect: true),
          ],
        ),
        PerguntaModel(
          tipo: TipoPergunta.lacuna,
          enunciado: 'Para Heidegger, o ser humano é um "ser-para-___".',
          explicacao:
              'Em "Ser e Tempo", Heidegger descreve o Dasein como '
              '"ser-para-a-morte": é a consciência da finitude que nos faz '
              'viver de forma autêntica.',
          respostas: [
            RespostaModel(texto: 'a-morte', isCorrect: true),
            RespostaModel(texto: 'o-prazer'),
            RespostaModel(texto: 'o-trabalho'),
            RespostaModel(texto: 'a-glória'),
          ],
        ),
        PerguntaModel(
          enunciado:
              'Para Kierkegaard, a angústia surge principalmente de quê?',
          explicacao:
              'Kierkegaard chama a angústia de "vertigem da liberdade": ela '
              'nasce diante da infinidade de possibilidades de escolha que se '
              'abrem à nossa frente.',
          respostas: [
            RespostaModel(
              texto: 'Da liberdade e do peso das possibilidades de escolha',
              isCorrect: true,
            ),
            RespostaModel(texto: 'Da falta de dinheiro'),
            RespostaModel(texto: 'Do medo de fenômenos naturais'),
            RespostaModel(texto: 'Da opinião dos outros'),
          ],
        ),
      ],
    ),
    TarefaModel(
      nome: 'O Absurdo e a Liberdade',
      tema: 'Existência',
      descricao: 'Camus, o mito de Sísifo e a vida sem desculpas.',
      enviadoPor: 'Prof. Exemplo',
      dataEnvio: '01/01/2025',
      perguntas: [
        PerguntaModel(
          enunciado: 'O que Albert Camus chama de "o absurdo"?',
          explicacao:
              'O absurdo nasce do confronto entre o ser humano, que busca '
              'sentido, e um universo que permanece silencioso e indiferente '
              'a essa busca.',
          respostas: [
            RespostaModel(
              texto:
                  'O choque entre nossa busca por sentido e o silêncio do mundo',
              isCorrect: true,
            ),
            RespostaModel(texto: 'Tudo aquilo que é engraçado'),
            RespostaModel(texto: 'As leis ilógicas da física quântica'),
            RespostaModel(texto: 'Os sonhos que não lembramos'),
          ],
        ),
        PerguntaModel(
          tipo: TipoPergunta.vf,
          enunciado:
              'Camus conclui o Mito de Sísifo dizendo que "é preciso imaginar '
              'Sísifo feliz".',
          explicacao:
              'Verdadeiro — mesmo condenado a empurrar a pedra eternamente, '
              'Sísifo encontra dignidade na revolta consciente. A frase '
              'encerra o ensaio.',
          respostas: [
            RespostaModel(texto: 'Verdadeiro', isCorrect: true),
            RespostaModel(texto: 'Falso'),
          ],
        ),
        PerguntaModel(
          tipo: TipoPergunta.lacuna,
          enunciado:
              'Em sua famosa conferência, Sartre afirma: "o existencialismo é '
              'um ___".',
          explicacao:
              '"O existencialismo é um humanismo" (1945) defende que, sem '
              'Deus ou essência prévia, o ser humano se torna inteiramente '
              'responsável pelo que é.',
          respostas: [
            RespostaModel(texto: 'humanismo', isCorrect: true),
            RespostaModel(texto: 'pessimismo'),
            RespostaModel(texto: 'materialismo'),
            RespostaModel(texto: 'misticismo'),
          ],
        ),
        PerguntaModel(
          enunciado: 'O que Sartre chama de "má-fé" (mauvaise foi)?',
          explicacao:
              'Má-fé é mentir para si mesmo: fingir que não somos livres e '
              'culpar circunstâncias, papéis sociais ou o destino pelas '
              'nossas próprias escolhas.',
          respostas: [
            RespostaModel(
              texto: 'Negar a própria liberdade fingindo não ter escolha',
              isCorrect: true,
            ),
            RespostaModel(texto: 'Enganar outras pessoas por dinheiro'),
            RespostaModel(texto: 'Não acreditar em nenhuma religião'),
            RespostaModel(texto: 'Quebrar promessas feitas em público'),
          ],
        ),
        PerguntaModel(
          tipo: TipoPergunta.vf,
          enunciado:
              'Para Sartre, somos responsáveis apenas pelas escolhas que '
              'fazemos conscientemente.',
          explicacao:
              'Falso — para Sartre a responsabilidade é total: até não '
              'escolher já é uma escolha, e somos responsáveis por tudo o que '
              'fazemos de nós.',
          respostas: [
            RespostaModel(texto: 'Verdadeiro'),
            RespostaModel(texto: 'Falso', isCorrect: true),
          ],
        ),
      ],
    ),

    TarefaModel(
      nome: 'O Eu e a Consciência',
      tema: 'Subjetividade',
      descricao: 'O autoconhecimento de Sócrates à psique de Freud.',
      enviadoPor: 'Prof. Exemplo',
      dataEnvio: '01/01/2025',
      perguntas: [
        PerguntaModel(
          enunciado:
              'A máxima "Conhece-te a ti mesmo" está associada a qual filósofo?',
          explicacao:
              'A frase estava inscrita no templo de Delfos e foi adotada por '
              'Sócrates como ponto de partida da reflexão filosófica: antes '
              'de conhecer o mundo, conheça a si mesmo.',
          respostas: [
            RespostaModel(texto: 'Sócrates', isCorrect: true),
            RespostaModel(texto: 'Aristóteles'),
            RespostaModel(texto: 'Epicuro'),
            RespostaModel(texto: 'Heráclito'),
          ],
        ),
        PerguntaModel(
          enunciado: 'Para Santo Agostinho, onde habita a verdade?',
          explicacao:
              'Agostinho ensina: "Não saias de ti, volta a ti mesmo; no '
              'interior do homem habita a verdade".',
          respostas: [
            RespostaModel(
              texto: 'No interior do próprio homem',
              isCorrect: true,
            ),
            RespostaModel(texto: 'Nas coisas exteriores ao homem'),
            RespostaModel(texto: 'Apenas nos livros sagrados'),
            RespostaModel(texto: 'Na opinião da maioria'),
          ],
        ),
        PerguntaModel(
          tipo: TipoPergunta.vf,
          enunciado:
              'Para David Hume, o "eu" é apenas um feixe de percepções em '
              'constante mudança.',
          explicacao:
              'Verdadeiro — Hume nega que exista um eu fixo e substancial: '
              'ao olhar para dentro, só encontramos percepções que se '
              'sucedem umas às outras.',
          respostas: [
            RespostaModel(texto: 'Verdadeiro', isCorrect: true),
            RespostaModel(texto: 'Falso'),
          ],
        ),
        PerguntaModel(
          tipo: TipoPergunta.lacuna,
          enunciado: 'Freud dividiu a psique humana em id, ego e ___.',
          explicacao:
              'O superego é a instância moral, formada pelas normas e '
              'valores internalizados — o "juiz interior" que regula o ego.',
          respostas: [
            RespostaModel(texto: 'superego', isCorrect: true),
            RespostaModel(texto: 'alma'),
            RespostaModel(texto: 'persona'),
            RespostaModel(texto: 'inconsciente'),
          ],
        ),
        PerguntaModel(
          enunciado:
              'Segundo John Locke, o que garante a identidade pessoal ao '
              'longo do tempo?',
          explicacao:
              'Para Locke, sou a mesma pessoa de ontem porque me lembro de '
              'ter sido ela: a continuidade da consciência (memória) é o '
              'critério da identidade pessoal.',
          respostas: [
            RespostaModel(
              texto: 'A continuidade da memória e da consciência',
              isCorrect: true,
            ),
            RespostaModel(texto: 'O corpo permanecer o mesmo'),
            RespostaModel(texto: 'O nome registrado em cartório'),
            RespostaModel(texto: 'A opinião que os outros têm de nós'),
          ],
        ),
      ],
    ),
    TarefaModel(
      nome: 'Identidade e Alteridade',
      tema: 'Subjetividade',
      descricao: 'O Outro, o navio de Teseu e os limites do eu.',
      enviadoPor: 'Prof. Exemplo',
      dataEnvio: '01/01/2025',
      perguntas: [
        PerguntaModel(
          enunciado:
              'Para Emmanuel Lévinas, a ética nasce de qual experiência?',
          explicacao:
              'Em Lévinas, o rosto do Outro me interpela e me torna '
              'responsável por ele antes de qualquer contrato ou lei: a '
              'ética é a relação com a alteridade.',
          respostas: [
            RespostaModel(
              texto: 'Do encontro face a face com o Outro',
              isCorrect: true,
            ),
            RespostaModel(texto: 'Da leitura das leis da cidade'),
            RespostaModel(texto: 'Do medo de punição divina'),
            RespostaModel(texto: 'Do cálculo de prazeres e dores'),
          ],
        ),
        PerguntaModel(
          tipo: TipoPergunta.vf,
          enunciado:
              'Para Descartes, mente e corpo são uma única e mesma substância.',
          explicacao:
              'Falso — Descartes é dualista: a mente (res cogitans) e o '
              'corpo (res extensa) são substâncias distintas que interagem.',
          respostas: [
            RespostaModel(texto: 'Verdadeiro'),
            RespostaModel(texto: 'Falso', isCorrect: true),
          ],
        ),
        PerguntaModel(
          tipo: TipoPergunta.lacuna,
          enunciado: 'O poeta Rimbaud escreveu: "Eu é um ___".',
          explicacao:
              '"Je est un autre" — a frase de Rimbaud sugere que o eu não é '
              'senhor de si mesmo: somos atravessados por forças que não '
              'controlamos.',
          respostas: [
            RespostaModel(texto: 'outro', isCorrect: true),
            RespostaModel(texto: 'mistério'),
            RespostaModel(texto: 'espelho'),
            RespostaModel(texto: 'sonho'),
          ],
        ),
        PerguntaModel(
          enunciado:
              'O paradoxo do navio de Teseu questiona principalmente o quê?',
          explicacao:
              'Se todas as pranchas do navio forem trocadas, ele ainda é o '
              'mesmo navio? O paradoxo discute o que garante a identidade de '
              'algo que muda com o tempo.',
          respostas: [
            RespostaModel(
              texto: 'Se algo que muda continuamente permanece o mesmo',
              isCorrect: true,
            ),
            RespostaModel(texto: 'Se navios antigos eram seguros'),
            RespostaModel(texto: 'Se Teseu realmente existiu'),
            RespostaModel(texto: 'Se a madeira é o melhor material naval'),
          ],
        ),
        PerguntaModel(
          tipo: TipoPergunta.vf,
          enunciado:
              'Para Simone de Beauvoir, "não se nasce mulher: torna-se mulher".',
          explicacao:
              'Verdadeiro — a frase abre o segundo volume de "O Segundo '
              'Sexo": a identidade feminina é construída social e '
              'historicamente, não dada pela natureza.',
          respostas: [
            RespostaModel(texto: 'Verdadeiro', isCorrect: true),
            RespostaModel(texto: 'Falso'),
          ],
        ),
      ],
    ),

    TarefaModel(
      nome: 'O Fluxo do Tempo',
      tema: 'Tempo',
      descricao: 'O devir de Heráclito e o tempo interior de Agostinho.',
      enviadoPor: 'Prof. Exemplo',
      dataEnvio: '01/01/2025',
      perguntas: [
        PerguntaModel(
          enunciado:
              'O que Heráclito quis dizer com "ninguém se banha duas vezes no mesmo rio"?',
          explicacao:
              'Para Heráclito tudo flui (panta rhei): o rio muda e nós também '
              'mudamos, por isso nenhuma experiência se repete de forma '
              'idêntica.',
          respostas: [
            RespostaModel(
              texto: 'Tudo está em constante mudança',
              isCorrect: true,
            ),
            RespostaModel(texto: 'A água dos rios é sagrada'),
            RespostaModel(texto: 'O passado pode ser revivido'),
            RespostaModel(texto: 'O movimento é uma ilusão'),
          ],
        ),
        PerguntaModel(
          enunciado:
              'Para Santo Agostinho, o tempo é melhor compreendido como:',
          explicacao:
              'Nas Confissões, Agostinho descreve o tempo como uma distensão '
              'da alma: o passado vive na memória, o presente na atenção e o '
              'futuro na espera.',
          respostas: [
            RespostaModel(texto: 'Uma distensão da alma', isCorrect: true),
            RespostaModel(texto: 'Um relógio cósmico exato'),
            RespostaModel(texto: 'Uma invenção da sociedade moderna'),
            RespostaModel(texto: 'Algo que não existe de forma alguma'),
          ],
        ),
        PerguntaModel(
          tipo: TipoPergunta.vf,
          enunciado:
              'Para Parmênides, o movimento e a mudança são ilusões dos '
              'sentidos.',
          explicacao:
              'Verdadeiro — ao contrário de Heráclito, Parmênides sustenta '
              'que o Ser é uno e imutável; a mudança que percebemos é '
              'aparência enganosa.',
          respostas: [
            RespostaModel(texto: 'Verdadeiro', isCorrect: true),
            RespostaModel(texto: 'Falso'),
          ],
        ),
        PerguntaModel(
          tipo: TipoPergunta.lacuna,
          enunciado:
              'Nietzsche propôs o experimento mental do eterno ___: viver '
              'esta mesma vida infinitas vezes.',
          explicacao:
              'O eterno retorno pergunta: se você tivesse que reviver esta '
              'exata vida para sempre, viveria de modo a poder dizer "sim" a '
              'ela?',
          respostas: [
            RespostaModel(texto: 'retorno', isCorrect: true),
            RespostaModel(texto: 'descanso'),
            RespostaModel(texto: 'esquecimento'),
            RespostaModel(texto: 'recomeço'),
          ],
        ),
        PerguntaModel(
          enunciado:
              'Henri Bergson distingue o tempo do relógio da "duração" '
              '(durée). O que é a duração?',
          explicacao:
              'A duração é o tempo vivido pela consciência: contínuo, '
              'qualitativo e elástico — uma hora de tédio e uma hora de '
              'alegria têm a mesma medida, mas não a mesma duração.',
          respostas: [
            RespostaModel(
              texto: 'O tempo vivido e qualitativo da consciência',
              isCorrect: true,
            ),
            RespostaModel(texto: 'O tempo medido pelos átomos de césio'),
            RespostaModel(texto: 'A vida útil dos objetos'),
            RespostaModel(texto: 'O intervalo entre dois eventos físicos'),
          ],
        ),
      ],
    ),
    TarefaModel(
      nome: 'Memória e Eternidade',
      tema: 'Tempo',
      descricao: 'De Kant a Proust: o tempo dentro de nós.',
      enviadoPor: 'Prof. Exemplo',
      dataEnvio: '01/01/2025',
      perguntas: [
        PerguntaModel(
          enunciado: 'Para Kant, o tempo é:',
          explicacao:
              'Kant argumenta que o tempo não é uma coisa no mundo, mas uma '
              'forma a priori da sensibilidade: a "lente" pela qual '
              'organizamos toda experiência.',
          respostas: [
            RespostaModel(
              texto: 'Uma forma a priori da nossa sensibilidade',
              isCorrect: true,
            ),
            RespostaModel(texto: 'Uma substância que flui no espaço'),
            RespostaModel(texto: 'Uma criação das civilizações agrícolas'),
            RespostaModel(texto: 'Um ser vivo que devora todas as coisas'),
          ],
        ),
        PerguntaModel(
          tipo: TipoPergunta.vf,
          enunciado:
              'A física de Einstein mostrou que o tempo passa exatamente '
              'igual para todos os observadores.',
          explicacao:
              'Falso — a relatividade mostra o oposto: o tempo passa de '
              'forma diferente conforme a velocidade e a gravidade. Não há '
              'um "agora" universal.',
          respostas: [
            RespostaModel(texto: 'Verdadeiro'),
            RespostaModel(texto: 'Falso', isCorrect: true),
          ],
        ),
        PerguntaModel(
          tipo: TipoPergunta.lacuna,
          enunciado:
              'O poeta Horácio cunhou a expressão "carpe ___" — aproveita o '
              'momento presente.',
          explicacao:
              '"Carpe diem, quam minimum credula postero": colhe o dia, e '
              'confia o mínimo possível no amanhã.',
          respostas: [
            RespostaModel(texto: 'diem', isCorrect: true),
            RespostaModel(texto: 'noctem'),
            RespostaModel(texto: 'vitam'),
            RespostaModel(texto: 'horam'),
          ],
        ),
        PerguntaModel(
          enunciado:
              'Em Proust, o que desperta a "memória involuntária" do narrador?',
          explicacao:
              'Ao molhar uma madeleine no chá, o sabor traz de volta toda a '
              'infância do narrador: a memória involuntária ressuscita o '
              'tempo perdido através dos sentidos.',
          respostas: [
            RespostaModel(
              texto: 'O sabor de uma madeleine molhada no chá',
              isCorrect: true,
            ),
            RespostaModel(texto: 'Uma fotografia antiga da família'),
            RespostaModel(texto: 'O som dos sinos da catedral'),
            RespostaModel(texto: 'Um sonho recorrente com o mar'),
          ],
        ),
        PerguntaModel(
          tipo: TipoPergunta.vf,
          enunciado:
              'Os estoicos ensinavam que devemos concentrar a atenção no '
              'presente, único tempo que de fato nos pertence.',
          explicacao:
              'Verdadeiro — Marco Aurélio repete: o passado já foi, o futuro '
              'não chegou; quem vive bem o presente vive tudo o que é '
              'possível viver.',
          respostas: [
            RespostaModel(texto: 'Verdadeiro', isCorrect: true),
            RespostaModel(texto: 'Falso'),
          ],
        ),
      ],
    ),

    TarefaModel(
      nome: 'Elogio do Ócio',
      tema: 'Ócio',
      descricao: 'Da skholé grega ao direito à preguiça de Lafargue.',
      enviadoPor: 'Prof. Exemplo',
      dataEnvio: '01/01/2025',
      perguntas: [
        PerguntaModel(
          enunciado: 'Para os gregos antigos, o ócio (skholé) era:',
          explicacao:
              'Skholé — origem da palavra "escola" — era o tempo livre '
              'dedicado ao estudo e à contemplação, não a simples '
              'inatividade.',
          respostas: [
            RespostaModel(
              texto: 'O tempo livre dedicado à contemplação e ao saber',
              isCorrect: true,
            ),
            RespostaModel(texto: 'Sinônimo de preguiça condenável'),
            RespostaModel(texto: 'Um castigo dos deuses'),
            RespostaModel(texto: 'O tempo dedicado ao trabalho braçal'),
          ],
        ),
        PerguntaModel(
          enunciado:
              'Qual pensador escreveu o manifesto "O Direito à Preguiça"?',
          explicacao:
              'Paul Lafargue, genro de Marx, escreveu "O Direito à Preguiça" '
              '(1880) criticando o culto ao trabalho da sociedade industrial.',
          respostas: [
            RespostaModel(texto: 'Paul Lafargue', isCorrect: true),
            RespostaModel(texto: 'Karl Marx'),
            RespostaModel(texto: 'Adam Smith'),
            RespostaModel(texto: 'Max Weber'),
          ],
        ),
        PerguntaModel(
          tipo: TipoPergunta.vf,
          enunciado:
              'Para Aristóteles, a contemplação (theoria) é a forma mais '
              'elevada de atividade humana.',
          explicacao:
              'Verdadeiro — na Ética a Nicômaco, a vida contemplativa é a '
              'mais próxima da felicidade plena, pois exercita o que há de '
              'melhor em nós: a razão.',
          respostas: [
            RespostaModel(texto: 'Verdadeiro', isCorrect: true),
            RespostaModel(texto: 'Falso'),
          ],
        ),
        PerguntaModel(
          tipo: TipoPergunta.lacuna,
          enunciado:
              'Para os romanos, o otium (ócio) era o oposto do ___ — a '
              'palavra que deu origem a "negócio".',
          explicacao:
              'Negotium é literalmente a negação do ócio (nec + otium): os '
              'romanos definiam o trabalho como ausência de tempo livre, e '
              'não o contrário.',
          respostas: [
            RespostaModel(texto: 'negotium', isCorrect: true),
            RespostaModel(texto: 'imperium'),
            RespostaModel(texto: 'studium'),
            RespostaModel(texto: 'labor'),
          ],
        ),
        PerguntaModel(
          enunciado:
              'No ensaio "O Elogio ao Ócio" (1932), Bertrand Russell defende que:',
          explicacao:
              'Russell propõe a jornada de 4 horas: com a técnica moderna, '
              'trabalhar menos liberaria tempo para a ciência, a arte e o '
              'pensamento — atividades que civilizam.',
          respostas: [
            RespostaModel(
              texto: 'Trabalhar menos tornaria a civilização mais criativa',
              isCorrect: true,
            ),
            RespostaModel(texto: 'O trabalho duro é o único caminho moral'),
            RespostaModel(texto: 'O descanso deve ser proibido aos jovens'),
            RespostaModel(texto: 'Só os ricos merecem tempo livre'),
          ],
        ),
      ],
    ),
    TarefaModel(
      nome: 'A Sociedade do Cansaço',
      tema: 'Ócio',
      descricao: 'Sêneca, Byung-Chul Han e a arte de não fazer nada.',
      enviadoPor: 'Prof. Exemplo',
      dataEnvio: '01/01/2025',
      perguntas: [
        PerguntaModel(
          enunciado:
              'Em "Sobre a Brevidade da Vida", Sêneca afirma que a vida:',
          explicacao:
              '"Não é que tenhamos pouco tempo: é que perdemos muito." Para '
              'Sêneca, a vida é longa o bastante para quem sabe usá-la.',
          respostas: [
            RespostaModel(
              texto: 'É longa o suficiente, se soubermos usá-la bem',
              isCorrect: true,
            ),
            RespostaModel(texto: 'É curta demais para qualquer projeto'),
            RespostaModel(texto: 'Só começa de verdade na velhice'),
            RespostaModel(texto: 'Deve ser dedicada inteiramente ao trabalho'),
          ],
        ),
        PerguntaModel(
          tipo: TipoPergunta.vf,
          enunciado:
              'Byung-Chul Han chama a sociedade atual de "sociedade do '
              'cansaço", marcada pela autoexploração do desempenho.',
          explicacao:
              'Verdadeiro — para Han, trocamos a disciplina imposta de fora '
              'pela cobrança interna do "você consegue": viramos patrões e '
              'escravos de nós mesmos.',
          respostas: [
            RespostaModel(texto: 'Verdadeiro', isCorrect: true),
            RespostaModel(texto: 'Falso'),
          ],
        ),
        PerguntaModel(
          tipo: TipoPergunta.lacuna,
          enunciado:
              'Para Josef Pieper, "o ócio é a base da ___" — sem tempo livre '
              'não há filosofia, arte ou ciência.',
          explicacao:
              'No livro homônimo de 1948, Pieper argumenta que a cultura '
              'nasce do ócio contemplativo, do tempo livre voltado para o '
              'que vale por si mesmo.',
          respostas: [
            RespostaModel(texto: 'cultura', isCorrect: true),
            RespostaModel(texto: 'economia'),
            RespostaModel(texto: 'política'),
            RespostaModel(texto: 'religião'),
          ],
        ),
        PerguntaModel(
          enunciado:
              'Quando Alexandre, o Grande, ofereceu realizar qualquer desejo '
              'de Diógenes, o filósofo respondeu:',
          explicacao:
              'Diógenes, deitado ao sol, pediu apenas: "sai da frente do meu '
              'sol". A anedota celebra a autossuficiência cínica frente ao '
              'poder e à riqueza.',
          respostas: [
            RespostaModel(texto: '"Sai da frente do meu sol"', isCorrect: true),
            RespostaModel(texto: '"Quero metade do teu império"'),
            RespostaModel(texto: '"Construa-me uma biblioteca"'),
            RespostaModel(texto: '"Liberta todos os escravos"'),
          ],
        ),
        PerguntaModel(
          tipo: TipoPergunta.vf,
          enunciado:
              'Henry David Thoreau escreveu "Walden" após viver dois anos '
              'isolado em uma cabana, defendendo uma vida simples e '
              'contemplativa.',
          explicacao:
              'Verdadeiro — Thoreau viveu à beira do lago Walden (1845-1847) '
              'para "viver deliberadamente" e descobrir o essencial da vida.',
          respostas: [
            RespostaModel(texto: 'Verdadeiro', isCorrect: true),
            RespostaModel(texto: 'Falso'),
          ],
        ),
      ],
    ),
  ];
}

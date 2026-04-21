import Foundation

enum DataError: Error, LocalizedError {
    case invalidJSON
    case decodingFailed(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidJSON: return "The embedded JSON data is corrupted."
        case .decodingFailed(let error): return "Failed to decode: \(error.localizedDescription)"
        }
    }
}

actor PoemDataLoader {
    static let shared = PoemDataLoader()
    
    private init() {}
    
    // 10 Curated Masterpieces with line-by-line Paraphrases and Poetic Style analysis.
    private let embeddedJSON = """
    [
      {
        "id": "A1B2C3D4-E5F6-4A7B-8C9D-0E1F2A3B4C5D",
        "title": "Inferno - Canto I (Excerpt)",
        "author": "Dante Alighieri",
        "era": "Medieval",
        "verses": [
          "Nel mezzo del cammin di nostra vita",
          "mi ritrovai per una selva oscura,",
          "ché la diritta via era smarrita.",
          "Ahi quanto a dir qual era è cosa dura",
          "esta selva selvaggia e aspra e forte",
          "che nel pensier rinova la paura!",
          "Tant' è amara che poco è più morte;",
          "ma per trattar del ben ch'i' vi trovai,",
          "dirò de l'altre cose ch'i' v'ho scorte.",
          "Io non so ben ridir com' i' v'intrai,",
          "tant' era pien di sonno a quel punto",
          "che la verace via abbandonai."
        ],
        "stanzas": [[0,1,2], [3,4,5], [6,7,8], [9,10,11]],
        "rhymeScheme": "Terza Rima (ABA BCB CDC)",
        "category": "epic",
        "themes": ["Religion", "Existential", "Landscape"],
        "paraphrases": {
          "0": "Having reached the midpoint of human life (around 35 years old),",
          "1": "I found myself wandering in a dark, tangled forest,",
          "2": "because the straight path of virtue had been completely lost.",
          "3": "Alas, it is so hard to describe what it was like,",
          "4": "this wild, harsh, and impenetrable forest",
          "5": "that just thinking about it renews my terror!",
          "6": "It is so bitter that death is scarcely worse;",
          "7": "but to recount the good things I eventually found there,",
          "8": "I will first describe the other terrible things I saw.",
          "9": "I cannot clearly explain how I entered it,",
          "10": "I was so full of sleep (spiritual numbness) at the moment",
          "11": "when I abandoned the true path of God."
        },
        "figures": {
          "0": "Metaphor",
          "1": "Metaphor",
          "4": "Alliteration",
          "10": "Metaphor"
        },
        "poeticStyle": "Dante invented the 'Terza Rima' (ABA BCB CDC), a driving, forward-moving rhyme scheme that perfectly mimics the physical momentum of walking a long journey. His style blends harsh realism with deep theological allegory, using the vernacular Florentine dialect to create a universal masterpiece.",
        "metrics": { "verseType": "Hendecasyllable", "syllableCounts": [11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11], "hasRhyme": true }
      },
      {
        "id": "F5E4D3C2-B1A0-9F8E-7D6C-5B4A39281701",
        "title": "L'infinito",
        "author": "Giacomo Leopardi",
        "era": "Romantic",
        "verses": [
          "Sempre caro mi fu quest'ermo colle,",
          "e questa siepe, che da tanta parte",
          "dell'ultimo orizzonte il guardo esclude.",
          "Ma sedendo e mirando, interminati",
          "spazi di là da quella, e sovrumani",
          "silenzi, e profondissima quïete",
          "io nel pensier mi fingo; ove per poco",
          "il cor non si spaura. E come il vento",
          "odo stormir tra queste piante, io quello",
          "infinito silenzio a questa voce",
          "vo comparando: e mi sovvien l'eterno,",
          "e le morte stagioni, e la presente",
          "e viva, e il suon di lei. Così tra questa",
          "immensità s'annega il pensier mio:",
          "e il naufragar m'è dolce in questo mare."
        ],
        "stanzas": [[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]],
        "rhymeScheme": "Blank Verse",
        "category": "lyrical",
        "themes": ["Nature", "Landscape", "Existential"],
        "paraphrases": {
          "0": "This lonely hill (Mount Tabor) was always dear to me,",
          "1": "as well as this hedge, which blocks the view",
          "2": "of so much of the distant horizon.",
          "3": "But sitting and gazing, I imagine endless",
          "4": "spaces existing beyond it, and superhuman",
          "5": "silences, and a profound, absolute quietness",
          "6": "in my mind; to the point where my heart",
          "7": "is almost terrified. And when I hear the wind",
          "8": "rustling through these leaves, I compare that",
          "9": "infinite silence to this earthly voice:",
          "10": "and I am reminded of eternity,",
          "11": "and the dead seasons of the past, and the present",
          "12": "living season, and its sound. Thus, amidst this",
          "13": "immensity, my thoughts completely drown:",
          "14": "and sinking in this sea is sweet to me."
        },
        "figures": {
          "3": "Hyperbole",
          "8": "Simile",
          "14": "Oxymoron"
        },
        "poeticStyle": "Leopardi's 'Idylls' masterfully use unrhymed hendecasyllables (endecasillabi sciolti) paired with heavy enjambment (breaking thoughts across lines). This creates a sprawling, breathless rhythm that perfectly simulates the overwhelming sensation of the human mind contemplating infinity.",
        "metrics": { "verseType": "Hendecasyllable", "syllableCounts": [11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11], "hasRhyme": false }
      },
      {
        "id": "22334455-6677-8899-00AA-BBCCDDEEFF00",
        "title": "Sonetto I",
        "author": "Francesco Petrarca",
        "era": "Medieval",
        "verses": [
          "Voi ch'ascoltate in rime sparse il suono",
          "di quei sospiri ond'io nudriva 'l core",
          "in sul mio primo giovenile errore",
          "quand'era in parte altr'uom da quel ch'i' sono,",
          "del vario stile in ch'io piango et ragiono",
          "fra le vane speranze e 'l van dolore,",
          "ove sia chi per prova intenda amore,",
          "spero trovar pietà, nonché perdono.",
          "Ma ben veggio or sì come al popol tutto",
          "favola fui gran tempo, onde sovente",
          "di me medesmo meco mi vergogno;",
          "et del mio vaneggiar vergogna è 'l frutto,",
          "e 'l pentirsi, e 'l conoscer chiaramente",
          "che quanto piace al mondo è breve sogno."
        ],
        "stanzas": [[0, 1, 2, 3], [4, 5, 6, 7], [8, 9, 10], [11, 12, 13]],
        "rhymeScheme": "ABBA ABBA CDE CDE",
        "category": "lyrical",
        "themes": ["Love", "Existential", "Religion"],
        "paraphrases": {
          "0": "You who listen, in these scattered rhymes, to the sound",
          "1": "of the sighs with which I fed my heart",
          "2": "during my first youthful error (obsessive love),",
          "3": "when I was, in part, a different man from who I am today,",
          "11": "and the fruit of my vain obsession is shame,",
          "12": "and repentance, and the clear realization",
          "13": "that everything that pleases us in this world is just a brief dream."
        },
        "figures": {
          "0": "Alliteration",
          "1": "Metaphor",
          "3": "Anaphora"
        },
        "poeticStyle": "Petrarca perfected the Italian Sonnet structure. His style is characterized by intense psychological introspection, musicality, and 'Petrarchan oxymorons' (like sweet pain or freezing fire) to express the contradictory agony of unrequited love.",
        "metrics": { "verseType": "Hendecasyllable", "syllableCounts": [11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11], "hasRhyme": true }
      },
      {
        "id": "11112222-3333-4444-5555-666677778888",
        "title": "S'i' fosse foco",
        "author": "Cecco Angiolieri",
        "era": "Medieval",
        "verses": [
          "S'i' fosse foco, arderei 'l mondo;",
          "s'i' fosse vento, lo tempesterei;",
          "s'i' fosse acqua, i' l'annegherei;",
          "s'i' fosse Dio, mandereil' en profondo;",
          "s'i' fosse papa, sare' allor giocondo,",
          "ché tutti cristïani imbrigherei;",
          "s'i' fosse 'mperator, sa' che farei?",
          "A tutti mozzarei lo capo a tondo.",
          "S'i' fosse morte, andarei da mio padre;",
          "s'i' fosse vita, fuggirei da lui:",
          "similemente faria da mi' madre.",
          "S'i' fosse Cecco, com'i' sono e fui,",
          "torrei le donne giovani e leggiadre:",
          "e vecchie e laide lasserei altrui."
        ],
        "stanzas": [[0, 1, 2, 3], [4, 5, 6, 7], [8, 9, 10], [11, 12, 13]],
        "rhymeScheme": "ABBA ABBA CDC DCD",
        "category": "didactic",
        "themes": ["Society", "Nature"],
        "paraphrases": {
          "0": "If I were fire, I would burn the world;",
          "1": "if I were the wind, I would hit it with storms;",
          "2": "if I were water, I would drown it;",
          "3": "if I were God, I would hurl it into the abyss;",
          "11": "But if I were simply Cecco, as I actually am and have been,",
          "12": "I would take all the beautiful, young women for myself,",
          "13": "and leave the old and ugly ones for everyone else."
        },
        "figures": {
          "0": "Anaphora",
          "1": "Anaphora",
          "2": "Anaphora",
          "3": "Hyperbole"
        },
        "poeticStyle": "Angiolieri is the master of 'Comic-Realistic' poetry. He actively parodied the ultra-serious, spiritual 'Stil Novo' (used by Dante), replacing spiritual love and angels with exaggerated, profane jokes about gambling, taverns, and women.",
        "metrics": { "verseType": "Hendecasyllable", "syllableCounts": [11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11], "hasRhyme": true }
      },
      {
        "id": "77889900-1122-33AA-BBCC-DDEEFF001155",
        "title": "A Zacinto",
        "author": "Ugo Foscolo",
        "era": "Romantic",
        "verses": [
          "Né più mai toccherò le sacre sponde",
          "ove il mio corpo fanciulletto giacque,",
          "Zacinto mia, che te specchi nell'onde",
          "del greco mar da cui vergine nacque",
          "Venere, e fea quelle isole feconde",
          "col suo primo sorriso, onde non tacque",
          "le tue limpide nubi e le tue fronde",
          "l'inclito verso di colui che l'acque",
          "cantò fatali, ed il diverso esiglio",
          "per cui bello di fama e di sventura",
          "baciò la sua petrosa Itaca Ulisse.",
          "Tu non altro che il canto avrai del figlio,",
          "o materna mia terra; a noi prescrisse",
          "il fato illacrimata sepoltura."
        ],
        "stanzas": [[0, 1, 2, 3], [4, 5, 6, 7], [8, 9, 10], [11, 12, 13]],
        "rhymeScheme": "ABAB ABAB CDE CED",
        "category": "lyrical",
        "themes": ["Landscape", "Death", "Love"],
        "paraphrases": {
          "0": "I will never again touch the sacred shores",
          "1": "where my body lay as a young child,",
          "2": "my dear Zacinto, you who mirror yourself in the waves",
          "11": "You will receive nothing but the poetry of your son (me),",
          "12": "oh my maternal homeland; because destiny has decreed for us",
          "13": "a burial in exile, where no one will come to weep."
        },
        "figures": {
          "1": "Metaphor",
          "13": "Personification"
        },
        "poeticStyle": "Foscolo embodies Neoclassicism tinged with early Romanticism. His syntax is deliberately complex, heavily imitating classical Latin sentence structures (like placing the verb at the very end of a stanza) to elevate the tone of his profound grief.",
        "metrics": { "verseType": "Hendecasyllable", "syllableCounts": [11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11], "hasRhyme": true }
      },
      {
        "id": "99001122-3344-55AA-BBCC-DDEEFF001177",
        "title": "Orlando Furioso (Excerpt)",
        "author": "Ludovico Ariosto",
        "era": "Renaissance",
        "verses": [
          "Le donne, i cavallier, l'arme, gli amori,",
          "le cortesie, l'audaci imprese io canto,",
          "che furo al tempo che passaro i Mori",
          "d'Africa il mare, e in Francia nocquer tanto,",
          "seguendo l'ire e i giovenil furori",
          "d'Agramante lor re, che si diè vanto",
          "di vendicar la morte di Troiano",
          "sopra re Carlo imperador romano.",
          "Dirò d'Orlando in un medesmo tratto",
          "cosa non detta in prosa mai, né in rima:",
          "che per amor venne in furore e matto,",
          "d'uom che sì saggio era stimato prima."
        ],
        "stanzas": [[0,1,2,3,4,5,6,7], [8,9,10,11]],
        "rhymeScheme": "Ottava Rima",
        "category": "epic",
        "themes": ["War", "Love"],
        "paraphrases": {
          "0": "I sing of the women, the knights, the battles, the loves,",
          "1": "the acts of chivalry, and the bold adventures,",
          "2": "which occurred at the time when the Moors crossed",
          "3": "the African sea and caused so much harm in France,",
          "8": "At the same time, I will tell a story about Orlando",
          "9": "that has never been told before in prose or rhyme:",
          "10": "how he went completely furious and insane because of love,",
          "11": "a man who was previously considered incredibly wise."
        },
        "figures": {
          "0": "Alliteration"
        },
        "poeticStyle": "Ariosto mastered the 'Ottava Rima' (stanzas of eight lines rhyming ABABABCC). This structure allows for a sweeping, musical narrative pace that seamlessly blends epic wartime action with deeply ironic, humanizing romance and madness.",
        "metrics": { "verseType": "Hendecasyllable", "syllableCounts": [11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11], "hasRhyme": true }
      },
      {
        "id": "AA112233-4455-66BB-CCDD-EEFF00118899",
        "title": "Il Cinque Maggio (Excerpt)",
        "author": "Alessandro Manzoni",
        "era": "Romantic",
        "verses": [
          "Ei fu. Siccome immobile,",
          "dato il mortal sospiro,",
          "stette la spoglia immemore",
          "orba di tanto spiro,",
          "così percossa, attonita",
          "la terra al nunzio sta,",
          "muta pensando all'ultima",
          "ora dell'uom fatale;",
          "né sa quando una simile",
          "orma di piè mortale",
          "la sua cruenta polvere",
          "a calpestar verrà."
        ],
        "stanzas": [[0,1,2,3,4,5], [6,7,8,9,10,11]],
        "rhymeScheme": "Ode (Settenari)",
        "category": "lyrical",
        "themes": ["Death", "War", "Religion"],
        "paraphrases": {
          "0": "He was. (Napoleon is dead). Just as his motionless,",
          "1": "lifeless body lay still after breathing his last breath,",
          "2": "unconscious of its past glory,",
          "3": "deprived of such a monumental spirit,",
          "4": "the entire world stands similarly struck and astonished",
          "5": "upon hearing the news of his passing,",
          "6": "silently reflecting on the final",
          "7": "moments of this destined, fatal man;"
        },
        "figures": {
          "0": "Metaphor",
          "2": "Personification"
        },
        "poeticStyle": "Manzoni uses the rapid, staccato rhythm of the 'Settenario' (7-syllable verses) to reflect the breathless shock of the world reacting to Napoleon's death. His style marries grand historical epic with profound Christian humility.",
        "metrics": { "verseType": "Settenario", "syllableCounts": [7,7,7,7,7,7,7,7,7,7,7,7], "hasRhyme": true }
      },
      {
        "id": "55667788-9900-11AA-BBCC-DDEEFF001133",
        "title": "Mattina",
        "author": "Giuseppe Ungaretti",
        "era": "Modern",
        "verses": [
          "M'illumino",
          "d'immenso"
        ],
        "stanzas": [[0, 1]],
        "rhymeScheme": "Free Verse",
        "category": "lyrical",
        "themes": ["War", "Nature", "Existential"],
        "paraphrases": {
          "0": "I am flooded with the light",
          "1": "of the infinite immensity."
        },
        "figures": {
          "0": "Metaphor",
          "1": "Hyperbole"
        },
        "poeticStyle": "Hermeticism. Ungaretti radically strips away all punctuation, traditional meter, and narrative context. He isolates words to their absolute essence, turning a fleeting moment in a WWI trench into a sudden flash of universal enlightenment.",
        "metrics": { "verseType": "Free Verse", "syllableCounts": [4, 3], "hasRhyme": false }
      },
      {
        "id": "66778899-0011-22AA-BBCC-DDEEFF001144",
        "title": "Ed è sùbito sera",
        "author": "Salvatore Quasimodo",
        "era": "Modern",
        "verses": [
          "Ognuno sta solo sul cuor della terra",
          "trafitto da un raggio di sole:",
          "ed è sùbito sera."
        ],
        "stanzas": [[0, 1, 2]],
        "rhymeScheme": "Free Verse",
        "category": "lyrical",
        "themes": ["Existential", "Death", "Nature"],
        "paraphrases": {
          "0": "Every person stands completely alone in the center of the world,",
          "1": "pierced by a beautiful but agonizing ray of sunlight (life):",
          "2": "and then suddenly, evening (death) arrives."
        },
        "figures": {
          "0": "Personification",
          "1": "Metaphor"
        },
        "poeticStyle": "Quasimodo uses Hermetic brevity to capture the tragic arc of human existence in just three lines: the illusion of centrality, the painful joy of living, and the rapid, inevitable onset of death.",
        "metrics": { "verseType": "Mixed", "syllableCounts": [12, 9, 7], "hasRhyme": false }
      },
      {
        "id": "33445566-7788-9900-AABB-CCDDEEFF0011",
        "title": "X Agosto (Excerpt)",
        "author": "Giovanni Pascoli",
        "era": "Modern",
        "verses": [
          "San Lorenzo, io lo so perché tanto",
          "di stelle per l'aria tranquilla",
          "arde e cade, perché si gran pianto",
          "nel concavo cielo sfavilla.",
          "Ritornava una rondine al tetto:",
          "l'uccisero: cadde tra' spini;",
          "ella aveva nel becco un insetto:",
          "la cena de' suoi rondinini.",
          "Ora è là, come in croce, che tende",
          "quel verme a quel cielo lontano;",
          "e il suo nido è nell'ombra, che attende,",
          "che pigola sempre più piano."
        ],
        "stanzas": [[0,1,2,3], [4,5,6,7], [8,9,10,11]],
        "rhymeScheme": "ABAB",
        "category": "lyrical",
        "themes": ["Death", "Nature"],
        "paraphrases": {
          "0": "Saint Lawrence, I know exactly why so many",
          "1": "stars are burning and falling through the calm air,",
          "2": "and why such a massive cosmic weeping",
          "3": "sparkles in the concave sky tonight.",
          "4": "A swallow was returning to its roof nest:",
          "5": "they killed her: and she fell among the thorns;",
          "6": "she held an insect in her beak:",
          "7": "it was the dinner meant for her baby swallows."
        },
        "figures": {
          "0": "Anaphora",
          "8": "Simile",
          "10": "Personification"
        },
        "poeticStyle": "Pascoli's 'Decadentismo' relies heavily on the 'fanciullino' (the inner child) perspective. He uses simple, domestic nature imagery (a swallow, a nest) as devastating symbols to process profound personal trauma and the inexplicable cruelty of the universe.",
        "metrics": { "verseType": "Mixed", "syllableCounts": [10, 9, 10, 9, 10, 9, 10, 9, 10, 9, 10, 9], "hasRhyme": true }
      }
    ]
    """
    
    func loadPoems() -> Result<[Poem], DataError> {
        guard let data = embeddedJSON.data(using: .utf8) else { return .failure(.invalidJSON) }
        do {
            let decoder = JSONDecoder()
            let decoded = try decoder.decode([Poem].self, from: data)
            return .success(decoded)
        } catch {
            return .failure(.decodingFailed(error))
        }
    }
}

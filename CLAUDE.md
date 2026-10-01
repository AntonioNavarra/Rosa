# CLAUDE.md

Guidance for Claude Code in this repository.

## What Rosa is, and for whom

Rosa is an iOS/iPadOS app (SwiftUI, iOS 26.2+, fully offline) that turns the **fundamentals of
Italian poetry and anthology** — authors, meter, rhyme schemes, rhetorical figures, themes — into
short, playful challenges. It is written with the author's sister in mind: someone deeply versed
in anthology and poetics, whose knowledge is the bar the content must meet.

**The problem it answers:** in a TikTok-paced world, students have no motivation to read long
anthology books. Rosa does not replace them; it keeps the basics alive and makes them fun.

**Two consequences that drive every decision:**

1. **Content accuracy is a silent failure and the most important rule here.** A wrong figure, a
   wrong syllable count, a quiz with two correct answers or a misattributed verse does not crash —
   it teaches something false, and an expert reader will catch it immediately. Verify any poem
   text, annotation or paraphrase against a reliable edition before adding it; when unsure, flag it
   instead of guessing.
2. **Sessions are short.** Every interaction should be readable and answerable in seconds; depth is
   opt-in (paraphrase disclosures, "poetic style" cards), never forced.

## Architecture (see the source for detail)

- `Data/DataLoader.swift` — `PoemDataLoader` actor; the 10-poem anthology is **JSON embedded in a
  string**. `Poem.paraphrases` / `Poem.figures` are keyed by **verse index** (string keys in JSON).
- `Views/` — Anthology tab (`PoemLibraryView` → `PoemDetailView` with Read / Analyze modes).
  The Analyze mode shows **hand-written** syllable counts and figures from the JSON, it computes nothing.
- `Games/` — "La Sfida di Rose": survival quiz, 3 lives, +10 per answer, six `ChallengeType`
  generators in `PoetsTrialView`. Rose's record (150) is hard-coded; personal best in `@AppStorage`.
- `Views/PoetryEditorView.swift` — "La Bottega": verse editor with syllable badges, template-based
  "Muse" (`OnDeviceMuseModel`, no AI), archive in `UserDefaults`.
- `Utilities/` — syllable counting by vowel groups (`BasicPoemAnalyzer`, the one in use);
  `AdvancedPoemAnalyzer` handles synalepha but is **not wired in**.

State lives in views (`@State`), poems are passed down as parameters; `AppEnvironment` only holds the
onboarding flag. Theme colours (parchment, cordovan, gold, ink) are **redeclared in most files** —
reuse the same RGB values until a shared theme exists.

Files carry `Dante` headers: the project was renamed from "Dante" to "Rosa"; onboarding still
says "VERSES".

## Commands

No package manager, no tests, no shared scheme yet (only `xcuserdata`).

- Build: `xcodebuild -project Rosa.xcodeproj -scheme Rosa -destination 'platform=iOS Simulator,name=iPhone 17' build`

## Git

Work on a feature branch, not `main`; `git status` before structural changes; small commits with
conventional prefixes (`feat:`/`fix:`/`refactor:`/`content:`/`chore:`/`docs:`). Push and merge only
when the user asks (`git push`/`git merge` are denied in `.claude/settings.json`).

## Known defects (found 2026-10-01, not yet fixed)

- Quiz: answer buttons stay active during the 0.6 s feedback → double score / double life loss.
- Missing word: `replacingOccurrences` blanks every substring match ("selva" inside "selvaggia").
- Theme challenge: distractors can be other themes of the same poem, i.e. also correct.
- Editor: `ForEach(0..<verses.count, id: \.self)` + index bindings + `onDelete` → out-of-range crash risk.
- Scramble: `ScrambleListWrapper`'s `@State items` can keep a stale order across consecutive scrambles.
- Nested `NavigationStack`s (root + Games + Studio); onboarding row "La Bottega" has `icon: ""`.
- Syllable counter ignores synalepha ("mi ritrovai per una selva oscura" → 12, not 11).
- Muse theme detection: `contains("or")` matches almost everything; 4-letter rhyme cases unreachable.
- Dead code: `Author`, `PoemCard`, `AdvancedPoemAnalyzer`, helpers in `Tools.swift`.
- Questionable annotations in the JSON (e.g. "Anaphora" on Petrarca, *Voi ch'ascoltate*, v. 4).

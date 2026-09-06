# DnC EUR — Lua → Squirrel port handover

Migrating the Divide_and_Conquer_EUR EOP Lua scripts to Squirrel (`.nut`) for the m2ex
Squirrel host. This document covers the **`eur/upgrades`** folder only (the first batch).

## Objective & hard rules
- Recreate each Lua file 1:1 as `.nut`, matching layout/comments/order where possible.
- **The mod's own function names, variable names, and local/global scope are sacred** — never
  rename or rescope them, never invent helpers with mod-specific logic. Rule applies to the
  MOD's code, NOT to engine/API names.
- **Engine/API calls are the target of the migration** — map EOP Lua API → the Squirrel
  scripting API, ImGui → squi (`::UI`), Lua stdlib → the `luaCompat` shim. Use squi's OWN
  constructs to achieve the RESULT; do NOT try to reshape squi to mimic ImGui syntax.
- No C++ changes. No builds run by the porter.
- Functionality is out of scope for the transliteration pass ("don't worry if it runs yet"),
  but code must be valid Squirrel and structurally faithful.

## Layout
- Source (read-only): `…/Divide_and_Conquer_EUR/eopData/eopScripts/eur/upgrades/*.lua`
  and the loader `…/eopScripts/luaPluginScript.lua`.
- Destination: `…/Divide_and_Conquer_EUR/script/` (this folder). Mirrors the source tree:
  ported files live under `script/eur/upgrades/`.
- `manifest.nut` → `{ name="eur", entry="main", apiVersion=1 }`.
- `main.nut` → requires OUR files only, in the original `luaPluginScript.lua` load order
  (dot-path module names). `helper.luaCompat` is required FIRST.
- The m2ex `…/m2ex/script` tree must NOT be touched — it loads first, then this mod loads.

## Status per file (11 upgrade files + shim)
DONE & clean (0 outstanding tags):
- `helper/luaCompat.nut` — NEW. Lua base-lib shims (see below).
- 7 pure-data files — mechanical, byte-exact strings, no API:
  `eurGeneralBGSwapData/Default/Default2/List/List2`, `eurUnitUpgradeDefault`, `eurUnitUpgradeList`.
- `eur/upgrades/eurUnitCardLoc.nut` — one function + two data tables.
- `eur/upgrades/eurLeaderHeirSwap.nut` — data + 3 functions, EOP calls mapped.

PARTIAL — EOP/stdlib mapped, **ImGui window bodies still to port** (tagged `// [GAP]`):
- `eur/upgrades/eurUnitUpgrades.nut` — 166 tags. Windows: `upgradeWindow` (L22–556),
  `ugSwapAccept` (L557–632). Also `checkAIUpgrades`, `list_edu_recruitable` (no UI).
- `eur/upgrades/eurGeneralBGSwap.nut` — 169 tags. Windows: `swapBGWindow` (L1192+),
  `bgSwapAccept`, `genUnlockNotifation`, `dorwinionGeneralBGCheck`, plus the tooltip helpers
  `upgTooltip`/`sdgTooltip`/`replenTooltip` (L139–240). **`checkcard` (L241–1189) is fully
  commented out** — the mod owner is moving that card-location logic elsewhere; leave it out.

## Transliteration conventions (Lua → Squirrel/Quirrel)
- Top-level global `ident = …` → `ident <- …`; top-level `function f(){}` stays (already global);
  reassignment of an existing global uses `=`.
- `nil`→`null`, `~=`→`!=`, `and/or/not`→`&&/||/!`, `..`→`+`, `#t`→`t.len()`.
- `then/do`→`{`, `end`→`}`, `elseif C then`→`} else if (C) {`; every condition parenthesised.
- `for k,v in pairs/ipairs(t) do`→`foreach (k,v in t) {`; `for i=a,b do`→`for(local i=a;i<=b;i++){`.
- `obj:method()`→`obj.method()`; `tostring(x)`→`("" + x)`; `--`→`//`, `--[[ ]]`→`/* */`.
- Lua single-quote strings → double-quote (Squirrel `'x'` is a char literal).
- Positional-only Lua table → Squirrel array `[...]`; keyed/mixed → table `{...}`; empty `{}` stays a table.
- Collections used with `.append`/`.insert`/`#`/positional were flipped from `{}` to `[]`:
  `current_heir_check`, `temp_gen_units`, `temp_card_list`, `free_upkeep_index`,
  `list_edu_table`, `list_edu_table_default`.

## API mapping — EOP → Squirrel scripting API (all DONE)
| Lua (EOP) | Squirrel |
|---|---|
| `M2TWEOPDU.getEduEntryByType(name)` | `units.get(name)` |
| `M2TWEOPDU.getEduEntry(index)` | `units.at(index)` |
| `M2TWEOP.scriptCommand(cmd,args)` | `game.runScriptCommand(cmd,args)` |
| `M2TWEOP.getCultureName(i)` | `game.cultureName(i)` |
| `M2TWEOP.getLocalFactionID()` | `game.localFactionId()` |
| `M2TWEOP.logGame(s)` | `println(s)` (clock arg dropped, per owner) |
| `stratmap.game.callConsole(cmd)` | `game.runConsoleCommand(cmd)` |
`hasOwnership` and other object methods carry over `:`→`.` (confirmed in the generated API).
`game` and `units` are global tables in the Squirrel host (`SqGame.cpp`, `SqUnitType.cpp`).

## Lua stdlib — `helper/luaCompat.nut` (DONE)
Quirrel ships stdlibs as `require`-modules, not globals, so the shim defines the globals the
Lua source expects: `math` (floor/ceil/abs/sqrt/pow/pi/huge + variadic min/max + Lua-semantics
random), `table` (insert/remove/getn), `bit` (bor/band/bxor/lshift/rshift/bnot), `print`
(tab-join + newline), `string` (format passthrough + LITERAL-only gsub), `select`.
Caveats: `string.gsub` does literal substring replace only (no Lua patterns); `select(n,…)`
returns a single value (Squirrel has no multi-return); `table.insert` position is passed through
(Lua 1-based vs Squirrel 0-based not adjusted).

## REMAINING WORK — port ImGui immediate UI → squi (the 335 `// [GAP]` tags)
squi HAS an immediate mode; this is a real port, not a flag, and NOT a syntax mimic. Use squi's
own idioms to achieve the same RESULT:

Immediate model: `UI.layoutAt(x,y)` starts a cursor; `UI.slot(w,h)`→[x,y] reserves a box;
`UI.sameLine()`/`UI.newLine()` control rows; immediate `UI.text/image/imageButton/bullet`
draw at the cursor and take face/colour from the `UI.pushFont`/`UI.pushStyle` scope;
`UI.canvas`+`UI.canvasDraw` give a per-frame callback for the `UI.d*` draws (`drawRect`,
`drawText`, `drawLine`, …). Windows are retained handles created once (see
`m2ex/script/ui/console.nut` for the canonical build-once + `widgetRect` per-frame pattern).

| ImGui | squi equivalent |
|---|---|
| `Begin(name,…)` / `End()` | `UI.window(title,w,h,x,y)` created once; **drop `End`** |
| `BeginChild` / `EndChild` | `UI.panel(...)` or `UI.beginGroup()`+`groupRect()`; **drop `EndChild`** |
| `SetNextWindowPos` / `SetNextWindowSize` | args to `UI.window(...)`, or `UI.widgetRect(win,x,y,w,h)` |
| `GetWindowPos` | `UI.contentRect(win)` |
| `SetNextWindowFocus` | `UI.raise(win)` |
| `SetCursorPosY` / `Indent` / `Unindent` | `UI.layoutAt` / `UI.slot` / explicit `UI.widgetRect` |
| `NewLine` | `UI.newLine()` |
| `SetNextWindowBgAlpha(a)` | `UI.setWidgetStyle(win, UI.Surface.window, [r,g,b,a])` |
| `PushStyleColor` / `PopStyleColor` | `UI.pushStyle({token=[r,g,b,a]})` / `UI.popStyle()` (or `setStyle`) |
| `SetWindowFontScale` | `UI.pushFont(font,sdf,size)` scope |
| `PushItemWidth` / `PopItemWidth` | `UI.pushStyle({[UI.Metric.itemWidth]=w})` / `popStyle()` |
| `Text` / `TextColored` | `UI.text(s)` / `UI.textColoured(s,r,g,b,a)` (already mapped) |
| `Button("x")` (if-clicked) | `h=UI.button("x")`; `UI.buttonClick(h, cb)` |
| `ImageButton(id,img,w,h)` | `UI.imageButton(img,w,h,…)`+`buttonClick` (drop id arg) |
| `Image` | `UI.image(img,w,h)` |
| `InputText` | `UI.input(…)` + `inputTextGet`/`inputChange` |
| `ProgressBar` | `UI.progress(…)` |
| simple text tooltip | `UI.tooltip(handle, text)` |
| `BeginTooltip`…`EndTooltip` (images/bullets) | `UI.beginTooltip()` … `UI.endTooltip()`; for an immediate site use `UI.tooltipAt`+`UI.tooltipContent` re-armed each frame |
| `IsItemHovered` | `UI.hover(handle)` |
| `IsItemActive` | `UI.focusedWidget()` / `UI.focus(handle)` |
| `IsMouseHoveringRect` | `UI.rectVisible(x,y,w,h)` / `UI.mouse.pos()` |
| `IsMouseClicked(b)` | `UI.mouse.clicked(b)` |
| `IsKeyDown(k)` | `UI.keyboard.down(k)` |
| `bit.bor(flags)` for window flags | squi window-flags array, or native `(a | b)` |

Key references to read before porting a window: `m2ex/script/squi.nut` (the `::UI` doc stub —
immediate layout ~L150–215, text/tooltip/bullet ~L355–510, image/imageButton/canvas ~L1037–1290,
style ~L1420–1470) and `m2ex/script/ui/console.nut` (working retained-window example).

## Known caveats to resolve during the UI port
- Lua multi-assign was carried over verbatim on flagged lines and is NOT valid Squirrel:
  `alias_text, changed = ImGui.InputText(...)` (eurUnitUpgrades L81) and
  `local a,b = ImGui.GetWindowPos()` (several sites). Rework when porting those calls.
- `ImGui.ImageButton` keeps a leading string-id arg that `UI.imageButton` has no slot for — drop it.
- Verify the flipped-to-array collections aren't also used as string-keyed maps anywhere.

## Tooling (session scratchpad — porter's own helpers, safe to recreate)
- `luadata2nut.py` — pure-data Lua-table → Squirrel converter (top-level `<-`, positional→array,
  comments, single-quote→double).
- `checknut.py <file>` — strips strings/comments, reports residual LIVE Lua tokens (should be 0).
- `remap.py <files>` — applies the EOP→Squirrel renames, strips+re-tags `// [GAP]` for live
  unmapped `ImGui.*`/residual EOP, flips array-collection decls `{}`→`[]`.
- `logfix.py <files>` — `M2TWEOP.logGame("P" + (""+os.clock()) + "S")` → `println("P" + "S")`.
- Re-tag rule: a line has a `// [GAP]` iff live code still contains an `ImGui.*` call.
  When a window is ported, its tags disappear on the next `remap.py` run.

## Current `// [GAP]` inventory: 335 total (eurGeneralBGSwap 169, eurUnitUpgrades 166)
All are ImGui immediate-mode UI calls — zero true capability gaps; every one maps per the table
above. Exact per-symbol line numbers: run
`grep -n "\[GAP\]" script/eur/upgrades/eurGeneralBGSwap.nut script/eur/upgrades/eurUnitUpgrades.nut`.

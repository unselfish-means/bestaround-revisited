# Best Around (Revisited)

A World of Warcraft addon by WIKR that plays a sound when you level up, earn an achievement, or die.
You choose the sounds for each event. Pick several and one is chosen at random each time.

Built on [Ace3](https://www.wowace.com/projects/ace3). One download works on every supported client.

## What it does

- Each event has its own on/off switch and its own set of sounds. An event with no sounds selected
  stays silent.
- If an event fires again within 5 seconds, the repeat is ignored, so one death doesn't play
  overlapping copies of the sound. Each event has its own 5-second window.
- Sounds play on the **Master** channel by default. You can switch to **SFX** or **Music** so they
  follow that volume slider instead.
- Settings are saved per AceDB profile. You can switch, copy, or reset profiles under
  **Options › AddOns › BestAround Revisited › Profiles**.

## Commands

`/bar` and `/bestaround` do the same thing.

```
/bar                    open the options
/bar test               play the achievement sound
/bar test level         play the level-up sound
/bar test death         play the death sound
```

The test commands, like the **Test** buttons in the options, play even when the event is turned off.
If the event has no sounds selected, they tell you so in chat.

## Supported clients

The single `.toc` lists every client build it supports:

| Client | Builds |
|---|---|
| Retail | 12.1.0, 12.0.7, 11.0.7, 11.0.5 |
| Mists of Pandaria Classic | 5.5.0 |
| Classic Era | 1.15.6 |
| WoW: Forever (Classic Plus) | 1.60.1 |

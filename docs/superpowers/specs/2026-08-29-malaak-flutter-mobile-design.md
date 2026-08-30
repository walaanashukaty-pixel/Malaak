# Malaak Flutter Mobile Design

## Goal
Build a real Flutter mobile application source for Android that preserves the approved Figma visual identity while restructuring navigation for a phone-first experience.

## Non-negotiable UX
- Arabic RTL first.
- No sidebar or drawer.
- Home is the control center for all major experiences.
- Bottom navigation has exactly four destinations: الرئيسية, ملاك, رحلتي, أنا.
- Malaak is the primary immediate-help entry point.
- Long-term domains live under رحلتي rather than as top-level navigation.
- Quick tools are action-oriented shortcuts, not courses.
- Use the approved palette: cream #FFFDF8, plum #3D2B4A, lavender #B8A8FF, rose #F6B5C8, sage #BFD8C1, gold #D4AF37, lilac #9B87FF, peach #FFD4A8, blue #93B5E1.
- Rounded premium cards, subtle lavender shadows, soft gradients, high whitespace, non-childish tone.

## V1 Screens
1. App shell with custom bottom navigation.
2. Home: greeting/check-in, Malaak-now hero, current journey, monthly focus, open follow-up, Malaak insight, quick tools.
3. Malaak: chat-style coaching UI with local demo responses and explicit demo/offline state.
4. رحلتي: primary/support/maintenance sections + all approved domains.
5. Domain detail: reusable presentation of goal, stage, current skill, evidence signals, next step.
6. أنا: journal, reports, personal manual, memories/privacy, tools, settings.
7. Journal: structured entries and quick add dialog.
8. Reports: behavioral progress cards and observed patterns, no fake healing percentages.
9. Tools: thought mirror, chaos mode, anger emergency, prepare conversation, missed person, decision support, need discovery, thinking classifier, feminine balance reset.

## Approved Journey Domains
- حالتي النفسية
- السلام الداخلي
- احتياجاتي
- آثار تجارب الطفولة
- نمط التعلق
- العلاقة الزوجية
- الإفراط في التفكير
- إدارة الغضب
- اتزان الأنوثة
- بوصلة الذكاء الأنثوي
- التشافي العاطفي

## Data Boundary
V1 is local/demo UI. No production AI, diagnosis, backend, auth, analytics, or clinical claims. All AI-like responses are visibly demo/local placeholders. Architecture must allow later replacement by API/repository services.

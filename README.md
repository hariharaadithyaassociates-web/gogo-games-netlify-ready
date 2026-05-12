# 🎮 GoGo Games — Complete Platform

[![Deploy to Netlify](https://www.netlify.com/img/deploy/button.svg)](https://app.netlify.com/start/deploy?repository=https://github.com/hariharaadithyaassociates-web/gogo-games-netlify-ready)

## Files
| File | Description |
|------|-------------|
| `index.html` | Main landing page — 24 games, auth, pricing, community |
| `creator.html` | Drag-and-drop game creator with canvas editor, preview, publish |
| `earnings.html` | Full earnings dashboard — revenue charts, payouts, monetization |

## 3-Step Setup

### 1. Supabase (Auth + Database) — Free
1. Go to https://supabase.com → New Project
2. Copy **Project URL** and **Anon Key**
3. Open `config.js` and set:
   - `supabaseUrl` → your Project URL
   - `supabaseAnonKey` → your anon public key
4. Run this SQL in Supabase SQL Editor:

```sql
CREATE TABLE profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id),
  username TEXT,
  email TEXT,
  plan TEXT DEFAULT 'free',
  created_at TIMESTAMPTZ DEFAULT now()
);
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
CREATE POLICY "select_own" ON profiles FOR SELECT USING (auth.uid() = id);
CREATE POLICY "insert_own" ON profiles FOR INSERT WITH CHECK (auth.uid() = id);
CREATE POLICY "update_own" ON profiles FOR UPDATE USING (auth.uid() = id);
```

5. Auth → Settings → disable email confirmation for testing

### 2. Stripe (Payments) — Free account
1. Go to https://dashboard.stripe.com → Products
2. Create **GoGo Pro** → $12/month recurring
3. Create **GoGo Studio** → $49/month recurring
4. Create a Payment Link for each product
5. Optional: Developers → API Keys → copy Publishable Key
6. In `config.js` set:
   - `paymentLinks.pro` → Pro Payment Link URL
   - `paymentLinks.studio` → Studio Payment Link URL
   - `stripePublishableKey` → your publishable key, optional

### 3. Deploy to Netlify — Free
1. Go to https://netlify.com → Add new site → Deploy manually
2. Drag the entire `gogogames/` folder
3. Live instantly at `yoursite.netlify.app`
4. Custom domain: Site Settings → Domain Management

## Features Checklist
- ✅ 24 real embeddable browser games
- ✅ Genre filter + search
- ✅ Wishlist/like buttons
- ✅ Fullscreen game player with fallback
- ✅ Supabase auth (signup/login/logout)
- ✅ User dashboard (plan, plays, member since)
- ✅ Stripe payments (Pro $12/mo, Studio $49/mo)
- ✅ Drag-and-drop Game Creator with canvas
- ✅ Game preview mode with physics
- ✅ Code editor drawer
- ✅ Publish flow with animated steps
- ✅ Earnings dashboard with Chart.js charts
- ✅ Revenue breakdown (ads, subs, IAP, tips)
- ✅ Withdrawal modal (PayPal, Bank, Crypto)
- ✅ Referral system UI
- ✅ 6 monetization toggle methods
- ✅ Custom cursor + particle canvas
- ✅ Scroll reveal animations
- ✅ Animated count-up stats
- ✅ Fully responsive (mobile/tablet/desktop)
- ✅ Keyboard shortcuts (ESC, Ctrl+Z, arrows)

## For Production
- Wire Stripe webhook to update `profiles.plan` in Supabase
- Add Supabase Storage for game assets
- Add real-time leaderboards with Supabase Realtime

# GoGo Games Launch Checklist

## 1. Supabase

1. Create a free Supabase project.
2. Open SQL Editor.
3. Paste and run `supabase-schema.sql`.
4. Go to Project Settings → API.
5. Copy:
   - Project URL
   - anon public key
6. Add them to `config.js`:
   - `supabaseUrl`
   - `supabaseAnonKey`

## 2. Stripe

Use Stripe Payment Links for the fastest static-site launch.

1. Create product: `GoGo Pro`, recurring, `$12/month`.
2. Create product: `GoGo Studio`, recurring, `$49/month`.
3. For each product, create a Payment Link.
4. Add them to `config.js`:
   - `paymentLinks.pro`
   - `paymentLinks.studio`
5. Optional: add your publishable key to `stripePublishableKey`.

Important: Payment Links can collect money immediately, but automatic plan unlocking needs a Stripe webhook or Netlify Function later.

## 3. Netlify

1. Go to Netlify.
2. Add new site.
3. Choose manual deploy.
4. Drag this entire `netlify-gogo-games` folder.
5. Open the generated `.netlify.app` URL.

## 4. Money Setup

To actually earn money:

- Add Stripe Payment Links for Pro/Studio.
- Add Google AdSense after the site is live and approved.
- Add affiliate links for gaming gear.
- Sell weekly tournament sponsor placements.
- Add analytics so you can prove traffic to sponsors.

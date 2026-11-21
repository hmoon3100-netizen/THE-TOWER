# THE TOWER — Online Starter

This is the next-stage code package for a public, read-only resident directory and a restricted admin area.

## Files
- `index.html`: public tower, 100,000-room facade, resident search, floor explorer, admin login and bulk name intake.
- `supabase_setup.sql`: database schema, public read-only access, and admin-only bulk room assignment.

## Publish checklist

### 1. Supabase database
1. Create a project at https://supabase.com/.
2. Open **SQL Editor**, paste all of `supabase_setup.sql`, and run it.
3. Find the **Project URL** and **anon/publishable key** in Project Settings / API.
4. In `index.html`, replace `YOUR_SUPABASE_PROJECT_URL` and `YOUR_SUPABASE_ANON_KEY`.
5. Never put the `service_role` key in browser code.

### 2. Administrator account
1. In Supabase **Authentication → Users**, create the admin user.
2. Set that user's `app_metadata` to `{"role":"admin"}` using the dashboard's supported metadata editor.
3. Sign in through the Administration panel on the site.
4. Do not put the admin role in user-editable `user_metadata`.

Public visitors can read residents, but the database does not grant them insert, update, or delete permissions. The bulk-add database function checks the signed-in user's `app_metadata` role.

### 3. Deploy on Vercel
1. Create a GitHub repository at https://github.com/new and upload `index.html` to its root.
2. Import the repository at https://vercel.com/new.
3. Deploy with the default static-site settings. Vercel will provide a public `*.vercel.app` address.

## Operation
Paste follower names or public handles one per line. Duplicate names (case-insensitive) are skipped; new residents receive the lowest available room number. The public page refreshes every 30 seconds. Room code `042-018` means floor 42, room 18.

## Important
This package is not live until you complete the external account setup and deployment. I cannot create accounts, accept terms, or authorize external services on your behalf. Never share passwords, recovery codes, or private keys in chat.

Use only names or public handles that people are comfortable displaying. Do not publish email addresses, phone numbers, home addresses, or other private information. Plan a simple correction/removal process before collecting real residents.

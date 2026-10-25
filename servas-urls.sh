#!/usr/bin/env bash
# Prints the local Servas dev URLs and checks which ones answer.
# Usage: bin/servas-urls

check() {
  local name="$1" url="$2" note="$3"
  if curl -s -o /dev/null --max-time 1 "$url"; then
    status="✅ up  "
  else
    status="❌ down"
  fi
  printf "%s  %-16s %-28s %s\n" "$status" "$name" "$url" "$note"
}

echo "── Front doors (browser / app) ─────────────────────────────"
check "🔑 Login pages"   "http://localhost:4455/login" "Kratos UI: sign up, log in, settings"
check "📬 Fake inbox"    "http://localhost:4436"       "Mailslurper: read login codes"
check "🏠 Servas API"    "http://localhost:3001/up"    "Rails (bin/rails server -p 3001)"
check "🔐 Kratos public" "http://localhost:4433/health/ready" "what the login pages call"
check "🎟  Hydra public"  "http://localhost:4444/health/ready" "tokens / OAuth start"
echo
echo "── Staff doors (admin only, never public) ──────────────────"
check "🔐 Kratos admin"  "http://localhost:4434/health/ready" "list / delete users"
check "🎟  Hydra admin"   "http://localhost:4445/health/ready" "clients, introspect"
echo
echo "Inside Docker: kratos:4433/4434  hydra:4444/4445  mailslurper:1025"
echo "Always use localhost (not 127.0.0.1) in the browser."

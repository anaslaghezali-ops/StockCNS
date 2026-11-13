# StockCNS

Plateforme de gestion de stock ChickNSter : dépôt central et restaurants, déduction du stock par les ventes, inventaires et écarts, propositions de commande.

## Contenu

- `index.html` : le site complet (une seule page).
- `supabase.sql` : création de la table, des droits d'accès et des données de départ. À exécuter une fois dans Supabase > SQL Editor.

## Mise en service

1. Créer un projet Supabase et exécuter `supabase.sql`.
2. Renseigner `SUPABASE_URL` et `SUPABASE_KEY` (clé publique « anon ») en haut du script de `index.html`.
3. Dans Supabase > Authentication, désactiver l'inscription libre et créer un compte par utilisateur.
4. Dans GitHub > Settings > Pages, publier la branche `gh-pages`.

## Données

Tout est stocké dans la table `stock_docs` (colonnes `col`, `id`, `data`). `col` vaut `sites`, `products`, `menu`, `sales`, `movements`, `counts` ou `config`. Seuls les utilisateurs connectés peuvent lire et écrire.

Le stock n'est pas stocké : il est recalculé à partir du dernier inventaire, des mouvements et des ventes.

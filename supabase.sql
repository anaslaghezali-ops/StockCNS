-- Stock ChickNSter : table, droits d'accès et données de départ.
-- À coller dans Supabase > SQL Editor, puis « Run ». Peut être relancé sans risque.

create table if not exists public.stock_docs (
  col text not null,
  id text not null,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now(),
  updated_by uuid default auth.uid(),
  primary key (col, id)
);

create or replace function public.stock_docs_touch() returns trigger
language plpgsql set search_path = '' as $$
begin
  new.updated_at := now();
  new.updated_by := auth.uid();
  return new;
end $$;

drop trigger if exists stock_docs_touch on public.stock_docs;
create trigger stock_docs_touch before insert or update on public.stock_docs
  for each row execute function public.stock_docs_touch();

-- Seuls les utilisateurs connectés lisent et modifient les données.
alter table public.stock_docs enable row level security;
revoke all on public.stock_docs from anon;
grant select, insert, update, delete on public.stock_docs to authenticated;

drop policy if exists stock_select on public.stock_docs;
drop policy if exists stock_insert on public.stock_docs;
drop policy if exists stock_update on public.stock_docs;
drop policy if exists stock_delete on public.stock_docs;
create policy stock_select on public.stock_docs for select to authenticated using (true);
create policy stock_insert on public.stock_docs for insert to authenticated with check (true);
create policy stock_update on public.stock_docs for update to authenticated using (true) with check (true);
create policy stock_delete on public.stock_docs for delete to authenticated using (true);

-- Données de départ : sites, produits, recettes des articles de caisse.
insert into public.stock_docs (col, id, data) values
  ('sites','depot','{"name": "Dépôt central", "type": "depot"}'::jsonb),
  ('sites','r1','{"name": "Restaurant 1", "type": "restaurant"}'::jsonb),
  ('sites','r2','{"name": "Restaurant 2", "type": "restaurant"}'::jsonb),
  ('sites','smwf7yj5ve0dc','{"name": "CNS Gauthier", "type": "restaurant"}'::jsonb),
  ('products','boisson','{"name": "Boisson (toutes marques)", "family": "Boissons", "unit": "pièce", "cost": null, "pack": null, "supplier": "", "minR": null, "tgtR": null, "minD": null, "tgtD": null}'::jsonb),
  ('products','painburger','{"name": "Pain burger", "family": "Pain", "unit": "pièce", "cost": null, "pack": null, "supplier": "", "minR": null, "tgtR": null, "minD": null, "tgtD": null}'::jsonb),
  ('products','poulet','{"name": "Pièce de poulet", "family": "Poulet", "unit": "pièce", "cost": null, "pack": null, "supplier": "", "minR": null, "tgtR": null, "minD": null, "tgtD": null}'::jsonb),
  ('products','sachetliv','{"name": "Sachet de livraison", "family": "Sachets", "unit": "pièce", "cost": null, "pack": null, "supplier": "", "minR": null, "tgtR": null, "minD": null, "tgtD": null}'::jsonb),
  ('products','boiteburger','{"name": "Boîte burger", "family": "Boîtes burger", "unit": "pièce", "cost": null, "pack": null, "supplier": "", "minR": null, "tgtR": null, "minD": null, "tgtD": null}'::jsonb),
  ('config','import','{"chicken": "poulet", "bun": "painburger", "box": "boiteburger", "bag": "sachetliv", "drink": "boisson"}'::jsonb),
  ('menu','classic-burgerster','{"name": "Classic Burgerster", "components": [{"pid": "poulet", "qty": 1}, {"pid": "painburger", "qty": 1}, {"pid": "boiteburger", "qty": 1}], "bag": true}'::jsonb),
  ('menu','redster-burger','{"name": "Redster burger", "components": [{"pid": "poulet", "qty": 1}, {"pid": "painburger", "qty": 1}, {"pid": "boiteburger", "qty": 1}], "bag": true}'::jsonb),
  ('menu','trufflester','{"name": "TruffleSter", "components": [{"pid": "poulet", "qty": 1}, {"pid": "painburger", "qty": 1}, {"pid": "boiteburger", "qty": 1}], "bag": true}'::jsonb),
  ('menu','hotster','{"name": "HotSter", "components": [{"pid": "poulet", "qty": 1}, {"pid": "painburger", "qty": 1}, {"pid": "boiteburger", "qty": 1}], "bag": true}'::jsonb),
  ('menu','classic-cbo','{"name": "Classic CBO", "components": [{"pid": "poulet", "qty": 1}, {"pid": "painburger", "qty": 1}, {"pid": "boiteburger", "qty": 1}], "bag": true}'::jsonb),
  ('menu','red-cbo','{"name": "Red CBO", "components": [{"pid": "poulet", "qty": 1}, {"pid": "painburger", "qty": 1}, {"pid": "boiteburger", "qty": 1}], "bag": true}'::jsonb),
  ('menu','compose-ton-burger','{"name": "Compose ton burger", "components": [{"pid": "poulet", "qty": 1}, {"pid": "painburger", "qty": 1}, {"pid": "boiteburger", "qty": 1}], "bag": true}'::jsonb),
  ('menu','menu-classic-burgerster','{"name": "Menu Classic Burgerster", "components": [{"pid": "poulet", "qty": 1}, {"pid": "painburger", "qty": 1}, {"pid": "boiteburger", "qty": 1}, {"pid": "boisson", "qty": 1}], "bag": true, "drink": true}'::jsonb),
  ('menu','menu-redster-burger','{"name": "Menu Redster Burger", "components": [{"pid": "poulet", "qty": 1}, {"pid": "painburger", "qty": 1}, {"pid": "boiteburger", "qty": 1}, {"pid": "boisson", "qty": 1}], "bag": true, "drink": true}'::jsonb),
  ('menu','menu-trufflester','{"name": "Menu TruffleSter", "components": [{"pid": "poulet", "qty": 1}, {"pid": "painburger", "qty": 1}, {"pid": "boiteburger", "qty": 1}, {"pid": "boisson", "qty": 1}], "bag": true, "drink": true}'::jsonb),
  ('menu','menu-hotster','{"name": "Menu Hotster", "components": [{"pid": "poulet", "qty": 1}, {"pid": "painburger", "qty": 1}, {"pid": "boiteburger", "qty": 1}, {"pid": "boisson", "qty": 1}], "bag": true, "drink": true}'::jsonb),
  ('menu','menu-classic-cbo','{"name": "Menu Classic CBO", "components": [{"pid": "poulet", "qty": 1}, {"pid": "painburger", "qty": 1}, {"pid": "boiteburger", "qty": 1}, {"pid": "boisson", "qty": 1}], "bag": true, "drink": true}'::jsonb),
  ('menu','menu-redster-cbo','{"name": "Menu Redster CBO", "components": [{"pid": "poulet", "qty": 1}, {"pid": "painburger", "qty": 1}, {"pid": "boiteburger", "qty": 1}, {"pid": "boisson", "qty": 1}], "bag": true, "drink": true}'::jsonb),
  ('menu','menu-compose-ton-burger','{"name": "Menu - Compose ton burger", "components": [{"pid": "poulet", "qty": 1}, {"pid": "painburger", "qty": 1}, {"pid": "boiteburger", "qty": 1}, {"pid": "boisson", "qty": 1}], "bag": true, "drink": true}'::jsonb),
  ('menu','menu-classic-smokedster','{"name": "Menu Classic SmokedSter", "components": [{"pid": "poulet", "qty": 1}, {"pid": "painburger", "qty": 1}, {"pid": "boiteburger", "qty": 1}, {"pid": "boisson", "qty": 1}], "bag": true, "drink": true}'::jsonb),
  ('menu','menu-red-smokedster','{"name": "Menu Red SmokedSter", "components": [{"pid": "poulet", "qty": 1}, {"pid": "painburger", "qty": 1}, {"pid": "boiteburger", "qty": 1}, {"pid": "boisson", "qty": 1}], "bag": true, "drink": true}'::jsonb),
  ('menu','1-red-stripster','{"name": "1 Red Stripster", "components": [{"pid": "poulet", "qty": 1}], "bag": true}'::jsonb),
  ('menu','1-classic-stripster','{"name": "1 Classic Stripster", "components": [{"pid": "poulet", "qty": 1}], "bag": true}'::jsonb),
  ('menu','menu-red-stripster','{"name": "Menu Red Stripster", "components": [{"pid": "poulet", "qty": 2}, {"pid": "boisson", "qty": 1}], "bag": true, "drink": true}'::jsonb),
  ('menu','menu-classic-stripster','{"name": "Menu Classic Stripster", "components": [{"pid": "poulet", "qty": 2}, {"pid": "boisson", "qty": 1}], "bag": true, "drink": true}'::jsonb),
  ('menu','coca','{"name": "Coca", "components": [{"pid": "boisson", "qty": 1}]}'::jsonb),
  ('menu','coca-zero','{"name": "Coca Zero", "components": [{"pid": "boisson", "qty": 1}]}'::jsonb),
  ('menu','sidi-ali','{"name": "Sidi Ali", "components": [{"pid": "boisson", "qty": 1}]}'::jsonb),
  ('menu','ajustement-2','{"name": "Ajustement 2", "components": [], "skip": true}'::jsonb),
  ('menu','ajustement-5','{"name": "Ajustement 5", "components": [], "skip": true}'::jsonb),
  ('menu','ajustement-6','{"name": "Ajustement 6", "components": [], "skip": true}'::jsonb),
  ('menu','frais-de-livraison','{"name": "Frais de livraison", "components": [], "skip": true}'::jsonb),
  ('menu','waffle-fries','{"name": "Waffle Fries", "components": [], "skip": true}'::jsonb),
  ('menu','mozzasticks','{"name": "Mozzasticks", "components": [], "skip": true}'::jsonb),
  ('menu','chilli-cheddar-bites','{"name": "Chilli cheddar bites", "components": [], "skip": true}'::jsonb),
  ('menu','pickles','{"name": "Pickles", "components": [], "skip": true}'::jsonb),
  ('menu','tasty-buffalo','{"name": "Tasty Buffalo", "components": [], "skip": true}'::jsonb),
  ('menu','big-tasty-buffalo','{"name": "BIG Tasty Buffalo", "components": [], "skip": true}'::jsonb),
  ('menu','cns','{"name": "CNS", "components": [], "skip": true}'::jsonb),
  ('menu','big-cns','{"name": "BIG CNS", "components": [], "skip": true}'::jsonb),
  ('menu','spicy-cloud','{"name": "Spicy Cloud", "components": [], "skip": true}'::jsonb),
  ('menu','sweet-fire','{"name": "Sweet & Fire", "components": [], "skip": true}'::jsonb),
  ('menu','white-ranch','{"name": "White Ranch", "components": [], "skip": true}'::jsonb),
  ('menu','smoked-barbecue','{"name": "Smoked Barbecue", "components": [], "skip": true}'::jsonb),
  ('menu','honey-sauce','{"name": "Honey sauce", "components": [], "skip": true}'::jsonb),
  ('menu','extra-large-sauce','{"name": "Extra large sauce", "components": [], "skip": true}'::jsonb)
on conflict (col, id) do nothing;

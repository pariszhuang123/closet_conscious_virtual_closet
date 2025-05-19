create table public.events (
  event_id uuid primary key default uuid_generate_v4(), -- Unique ID for each event
  event_name text not null default 'cc_none',           -- Human-readable name of the event
  location text not null,                               -- Location (can be turned into a Google Maps link in app)
  event_date date not null,                             -- The calendar date of the event
  start_time timestamptz not null,                      -- Start time with timezone
  end_time timestamptz not null,                        -- End time with timezone
  event_status text not null default 'active' check (
    event_status in ('active', 'expired', 'deleted')),
  user_id uuid not null references public.user_profiles(id) on delete restrict,  -- Event creator
  closet_id uuid not null references public.user_closets(closet_id) on delete restrict, -- Related closet
  description text not null default 'cc_none',          -- Description of the event
  social_tags text not null default '#closetconscious', -- Social tags (e.g., for sharing or grouping)
  created_at timestamptz not null default now(),        -- Timestamp when created
  updated_at timestamptz not null default now()         -- Timestamp when last updated
);

comment on table public.events is
  'Stores information about events such as swaps, community meetups, or closet transfers.';

comment on column public.events.event_id is
  'Unique identifier for the event (UUID v4).';

comment on column public.events.event_name is
  'Name/title of the event. Defaults to "cc_none" if not set.';

comment on column public.events.location is
  'Location of the event. This should be used to generate a link to Google Maps.';

comment on column public.events.event_date is
  'The date on which the event takes place.';

comment on column public.events.start_time is
  'Start time of the event with timezone.';

comment on column public.events.end_time is
  'End time of the event with timezone.';

comment on column public.events.event_status is
  'Lifecycle status of the event. Allowed values: active, expired, deleted';

comment on column public.events.user_id is
  'Reference to the user who created or owns the event. FK to user_profile.';

comment on column public.events.closet_id is
  'Reference to the user closet associated with this event.';

comment on column public.events.description is
  'Full text description of the event. Defaults to "cc_none".';

comment on column public.events.social_tags is
  'Text for social tags, e.g., for hashtags or campaign purposes. Default is "#closetconscious".';

comment on column public.events.created_at is
  'Timestamp indicating when the event record was created.';

comment on column public.events.updated_at is
  'Timestamp indicating when the event record was last updated.';

alter table public.events enable row level security;

create policy "Allow event owner to read"
on public.events
for select
to authenticated
using (
  (SELECT auth.uid() AS uid) = user_id
);

create policy "Allow users to insert their own events"
on public.events
for insert
to authenticated
with check (
  (SELECT auth.uid() AS uid) = user_id
);

create policy "Allow event owners to update"
on public.events
for update
to authenticated
using (
  (SELECT auth.uid() AS uid) = user_id
)
with check (
  (SELECT auth.uid() AS uid) = user_id
);

create policy "Block deletes of events"
on public.events
for delete
to authenticated
using (false);

create table item_transfers (
  id uuid primary key default uuid_generate_v4(),
  item_id uuid not null references items(id),
  from_user uuid not null references user_profiles(id) on delete restrict,
  to_user uuid not null references user_profiles(id) on delete restrict,
  created_at timestamptz not null default now()
);

-- Table-level comment
comment on table public.item_transfers is
  'Tracks the transfer of an item between users, such as via QR code or manual handover. Each row represents one transfer event.';

-- Column-level comments
comment on column public.item_transfers.id is
  'Unique ID for the transfer record, generated using UUID v4.';

comment on column public.item_transfers.item_id is
  'Reference to the item being transferred. Foreign key to the items table.';

comment on column public.item_transfers.from_user is
  'The UUID of the user who initiated or owned the item before transfer. FK to user_profile, deletion restricted.';

comment on column public.item_transfers.to_user is
  'The UUID of the user receiving the item. FK to user_profile, deletion restricted.';

comment on column public.item_transfers.created_at is
  'Timestamp indicating when the transfer was created. Default is the current time.';

alter table public.item_transfers enable row level security;

create policy "Allow transfer participants to select"
on public.item_transfers
for select
to authenticated
using (
  (SELECT auth.uid()) = from_user OR
  (SELECT auth.uid()) = to_user
);

create policy "Allow to_user to insert"
on public.item_transfers
for insert
to authenticated
with check (
  (SELECT auth.uid() AS uid) = to_user
);

-- Optional: explicitly block update/delete
create policy "Block updates to transfers"
on public.item_transfers
for update
to authenticated
using (false);

create policy "Block deletes to transfers"
on public.item_transfers
for delete
to authenticated
using (false);

create or replace function transfer_item_ownership(
  p_item_id uuid,
  p_new_owner_id uuid
)
returns boolean
language plpgsql
security definer
as $$
declare
  v_current_owner_id uuid;
begin
  -- Attempt to get current owner
  select current_owner_id
  into v_current_owner_id
  from public.items
  where id = p_item_id;

  -- If no such item found
  if not found then
    return false;
  end if;

  -- Prevent self-transfer
  if v_current_owner_id = p_new_owner_id then
    return false;
  end if;

  -- Insert into item_transfers
  insert into public.item_transfers (
    item_id,
    from_user,
    to_user
  ) values (
    p_item_id,
    v_current_owner_id,
    p_new_owner_id
  );

  -- Update the current owner
  update public.items
  set current_owner_id = p_new_owner_id,
      updated_at = now()
  where id = p_item_id;

  return true;
end;
$$;

-- inserts a row into public.profiles
CREATE OR REPLACE FUNCTION public.sync_user_profile()
    RETURNS TRIGGER
    SECURITY DEFINER
    SET search_path = ''
AS $$

BEGIN
  INSERT INTO public.user_profiles (id, email, name, role, created_at, updated_at)
  VALUES (new.id, new.raw_user_meta_data ->> 'name', new.email, 'authenticated', now(), now());
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Insert upload_accessory_metadata
create  OR REPLACE function upload_accessory_metadata(
  _item_type text,
  _image_url text,
  _name text,
  _amount_spent numeric,
  _occasion text,
  _season text,
  _colour text,
  _colour_variations text,
  _accessory_type text
)
    returns void
    SET search_path = ''
as $$

declare
  items_item_id uuid;
  current_user_id uuid := auth.uid();
begin
  -- Insert into items table and get the generated item_id
  insert into public.items (item_type, image_url, name, amount_spent, occasion, season, colour, colour_variations)
  values (_item_type, _image_url, _name, _amount_spent, _occasion, _season, _colour, _colour_variations)
  returning item_id into items_item_id;

  -- Insert into items_clothing_basic table
  insert into public.items_clothing_basic (item_id, accessory_type)
  values (items_item_id, _accessory_type);

  -- Update user_high_freq_stats table
  update public.user_high_freq_stats
  set items_uploaded = items_uploaded + 1
  where user_id = current_user_id;
end;
$$ language plpgsql;


-- Insert upload_clothing_metadata

create OR REPLACE function upload_item_metadata(
  _item_type text,
  _image_url text,
  _name text,
  _amount_spent numeric,
  _occasion text,
  _season text,
  _colour text,
  _colour_variations text,
  _clothing_type text,
  _clothing_layer text
)
    returns void
    SET search_path = ''

as $$
declare
  items_item_id uuid;
  current_user_id uuid := auth.uid();
begin
  -- Insert into items table and get the generated item_id
  insert into public.items (item_type, image_url, name, amount_spent, occasion, season, colour, colour_variations)
  values (_item_type, _image_url, _name, _amount_spent, _occasion, _season, _colour, _colour_variations)
  returning item_id into items_item_id;

  -- Insert into items_clothing_basic table
  insert into public.items_clothing_basic (item_id, clothing_type, clothing_layer)
  values (items_item_id, _clothing_type, _clothing_layer);

  -- Update user_high_freq_stats table
  update public.user_high_freq_stats
  set items_uploaded = items_uploaded + 1
  where user_id = current_user_id;
end;
$$ language plpgsql;

-- Insert upload_shoes_metadata

create OR REPLACE function upload_shoes_metadata(
  _item_type text,
  _image_url text,
  _name text,
  _amount_spent numeric,
  _occasion text,
  _season text,
  _colour text,
  _colour_variations text,
  _shoes_type text
)
    returns void
    SET search_path = ''

as $$
declare
  items_item_id uuid;
  current_user_id uuid := auth.uid();
begin
  -- Insert into items table and get the generated item_id
  insert into public.items (item_type, image_url, name, amount_spent, occasion, season, colour, colour_variations)
  values (_item_type, _image_url, _name, _amount_spent, _occasion, _season, _colour, _colour_variations)
  returning item_id into items_item_id;

  -- Insert into items_clothing_basic table
  insert into public.items_clothing_basic (item_id, shoes_type)
  values (items_item_id, _shoes_type);

  -- Update user_high_freq_stats table
  update public.user_high_freq_stats
  set items_uploaded = items_uploaded + 1
  where user_id = current_user_id;
end;
$$ language plpgsql;

-- Inserts a row into public.user_low_freq_stats
CREATE OR REPLACE FUNCTION public.sync_user_low_freq_stats()
    RETURNS TRIGGER
    SET search_path = ''

AS $$
BEGIN
  INSERT INTO public.user_low_freq_stats (user_id)
  VALUES (NEW.id);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Inserts a row into public.user_high_freq_stats
CREATE OR REPLACE FUNCTION public.sync_user_high_freq_stats()
    RETURNS TRIGGER
    SET search_path = ''

AS $$
BEGIN
  INSERT INTO public.user_high_freq_stats (user_id)
  VALUES (NEW.id);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Increment analytics requests
CREATE OR REPLACE FUNCTION increment_analytics_request(p_user_id uuid)
    RETURNS void
    SET search_path = ''
AS $$

BEGIN
    UPDATE public.user_low_freq_stats
    SET analytics_request = analytics_request + 1
    WHERE user_id = p_user_id;
END;
$$ LANGUAGE plpgsql;

-- Increment filter requests
CREATE OR REPLACE FUNCTION increment_filter_request(p_user_id uuid)
    RETURNS void
    SET search_path = ''
AS $$

BEGIN
    UPDATE public. user_low_freq_stats
    SET filter_request = filter_request + 1
    WHERE user_id = p_user_id;
END;
$$ LANGUAGE plpgsql;
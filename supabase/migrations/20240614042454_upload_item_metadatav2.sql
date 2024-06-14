-- Your SQL function definition
create function upload_item_metadata(
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
returns void as $$
declare
  items_item_id uuid;
begin
  -- Insert into items table and get the generated item_id
  insert into items (item_type, image_url, name, amount_spent, occasion, season, colour, colour_variations)
  values (_item_type, _image_url, _name, _amount_spent, _occasion, _season, _colour, _colour_variations)
  returning item_id into items_item_id;

  -- Insert into items_clothing_basic table
  insert into items_clothing_basic (item_id, clothing_type, clothing_layer)
  values (items_item_id, _clothing_type, _clothing_layer);
end;
$$ language plpgsql;

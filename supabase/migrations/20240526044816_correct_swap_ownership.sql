-- Ensure correct user ownership update on swap completion
CREATE OR REPLACE FUNCTION update_item_ownership()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.status = 'completed' THEN
        UPDATE items
        SET user_id = NEW.new_owner_id, updated_at = NOW()
        WHERE item_id = NEW.item_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to update item ownership on swap status update
CREATE TRIGGER trg_update_item_ownership
AFTER UPDATE ON swaps
FOR EACH ROW
WHEN (NEW.status = 'completed')
EXECUTE FUNCTION update_item_ownership();

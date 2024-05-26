-- Enable RLS on all tables
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE items ENABLE ROW LEVEL SECURITY;
ALTER TABLE outfits ENABLE ROW LEVEL SECURITY;
ALTER TABLE outfit_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE disliked_outfit_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE swaps ENABLE ROW LEVEL SECURITY;
ALTER TABLE premium_services ENABLE ROW LEVEL SECURITY;
ALTER TABLE challenges ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_goals ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_high_freq_stats ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_low_freq_stats ENABLE ROW LEVEL SECURITY;

-- Policies for user_profiles table
CREATE POLICY "Allow individual user access"
ON user_profiles
FOR SELECT USING (user_id = auth.uid());

CREATE POLICY "Allow individual user update"
ON user_profiles
FOR UPDATE USING (user_id = auth.uid());

CREATE POLICY "Allow individual user deletion"
ON user_profiles
FOR DELETE USING (user_id = auth.uid());

-- Policies for items table
CREATE POLICY "Allow user to access own items"
ON items
FOR SELECT USING (user_id = auth.uid());

CREATE POLICY "Allow user to modify own items"
ON items
FOR UPDATE USING (user_id = auth.uid());

CREATE POLICY "Allow user to delete own items"
ON items
FOR DELETE USING (user_id = auth.uid());

CREATE POLICY "Allow user to insert items"
ON items
FOR INSERT WITH CHECK (user_id = auth.uid());

-- Policies for outfits table
CREATE POLICY "Allow user to access own outfits"
ON outfits
FOR SELECT USING (user_id = auth.uid());

CREATE POLICY "Allow user to modify own outfits"
ON outfits
FOR UPDATE USING (user_id = auth.uid());

CREATE POLICY "Allow user to delete own outfits"
ON outfits
FOR DELETE USING (user_id = auth.uid());

CREATE POLICY "Allow user to insert outfits"
ON outfits
FOR INSERT WITH CHECK (user_id = auth.uid());

-- Policies for outfit_items table
CREATE POLICY "Allow user to access own outfit items"
ON outfit_items
FOR SELECT USING (user_id = auth.uid());

CREATE POLICY "Allow user to modify own outfit items"
ON outfit_items
FOR UPDATE USING (user_id = auth.uid());

CREATE POLICY "Allow user to delete own outfit items"
ON outfit_items
FOR DELETE USING (user_id = auth.uid());

CREATE POLICY "Allow user to insert outfit items"
ON outfit_items
FOR INSERT WITH CHECK (user_id = auth.uid());

-- Policies for disliked_outfit_items table
CREATE POLICY "Allow user to access own disliked outfit items"
ON disliked_outfit_items
FOR SELECT USING (user_id = auth.uid());

CREATE POLICY "Allow user to modify own disliked outfit items"
ON disliked_outfit_items
FOR UPDATE USING (user_id = auth.uid());

CREATE POLICY "Allow user to delete own disliked outfit items"
ON disliked_outfit_items
FOR DELETE USING (user_id = auth.uid());

CREATE POLICY "Allow user to insert disliked outfit items"
ON disliked_outfit_items
FOR INSERT WITH CHECK (user_id = auth.uid());

-- Policies for swaps table

-- Allow both the original owner and the new owner to access their own swaps
CREATE POLICY "Allow user to access own swaps"
ON swaps
FOR SELECT USING (owner_id = auth.uid() OR new_owner_id = auth.uid());

-- Allow the original owner to modify the swap until it is completed
CREATE POLICY "Allow owner to modify swaps"
ON swaps
FOR UPDATE USING (owner_id = auth.uid() AND status != 'completed');

-- Allow the new owner to modify the swap after it is completed
CREATE POLICY "Allow new owner to modify completed swaps"
ON swaps
FOR UPDATE USING (new_owner_id = auth.uid() AND status = 'completed');

-- Allow the new owner to delete the swap to comply with GDPR
CREATE POLICY "Allow new owner to delete swaps"
ON swaps
FOR DELETE USING (new_owner_id = auth.uid());

-- Allow users to insert swaps
CREATE POLICY "Allow user to insert swaps"
ON swaps
FOR INSERT WITH CHECK (owner_id = auth.uid() OR new_owner_id = auth.uid());

-- Policies for premium_services table
CREATE POLICY "Allow user to access own premium services"
ON premium_services
FOR SELECT USING (user_id = auth.uid());

CREATE POLICY "Allow user to modify own premium services"
ON premium_services
FOR UPDATE USING (user_id = auth.uid());

CREATE POLICY "Allow user to delete own premium services"
ON premium_services
FOR DELETE USING (user_id = auth.uid());

CREATE POLICY "Allow user to insert premium services"
ON premium_services
FOR INSERT WITH CHECK (user_id = auth.uid());

-- Policies for challenges table
CREATE POLICY "Allow user to access own challenges"
ON challenges
FOR SELECT USING (user_id = auth.uid());

CREATE POLICY "Allow user to modify own challenges"
ON challenges
FOR UPDATE USING (user_id = auth.uid());

CREATE POLICY "Allow user to delete own challenges"
ON challenges
FOR DELETE USING (user_id = auth.uid());

CREATE POLICY "Allow user to insert challenges"
ON challenges
FOR INSERT WITH CHECK (user_id = auth.uid());

-- Policies for user_goals table
CREATE POLICY "Allow user to access own goals"
ON user_goals
FOR SELECT USING (user_id = auth.uid());

CREATE POLICY "Allow user to modify own goals"
ON user_goals
FOR UPDATE USING (user_id = auth.uid());

CREATE POLICY "Allow user to delete own goals"
ON user_goals
FOR DELETE USING (user_id = auth.uid());

CREATE POLICY "Allow user to insert goals"
ON user_goals
FOR INSERT WITH CHECK (user_id = auth.uid());

-- Policies for user_high_freq_stats Table
CREATE POLICY "Allow user to access own high freq stats"
ON user_high_freq_stats
FOR SELECT USING (user_id = auth.uid());

CREATE POLICY "Allow user to modify own high freq stats"
ON user_high_freq_stats
FOR UPDATE USING (user_id = auth.uid());

CREATE POLICY "Allow user to delete own high freq stats"
ON user_high_freq_stats
FOR DELETE USING (user_id = auth.uid());

CREATE POLICY "Allow user to insert high freq stats"
ON user_high_freq_stats
FOR INSERT WITH CHECK (user_id = auth.uid());

-- Policies for user_low_freq_stats table
CREATE POLICY "Allow user to access own low freq stats"
ON user_low_freq_stats
FOR SELECT USING (user_id = auth.uid());

CREATE POLICY "Allow user to modify own low freq stats"
ON user_low_freq_stats
FOR UPDATE USING (user_id = auth.uid());

CREATE POLICY "Allow user to delete own low freq stats"
ON user_low_freq_stats
FOR DELETE USING (user_id = auth.uid());

CREATE POLICY "Allow user to insert low freq stats"
ON user_low_freq_stats
FOR INSERT WITH CHECK (user_id = auth.uid());

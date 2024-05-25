-- Enable RLS on all tables
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
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

-- Add archived column to implement soft delete
ALTER TABLE users ADD COLUMN archived BOOLEAN DEFAULT false;
ALTER TABLE items ADD COLUMN archived BOOLEAN DEFAULT false;
ALTER TABLE outfits ADD COLUMN archived BOOLEAN DEFAULT false;
ALTER TABLE outfit_items ADD COLUMN archived BOOLEAN DEFAULT false;
ALTER TABLE disliked_outfit_items ADD COLUMN archived BOOLEAN DEFAULT false;
ALTER TABLE swaps ADD COLUMN archived BOOLEAN DEFAULT false;
ALTER TABLE premium_services ADD COLUMN archived BOOLEAN DEFAULT false;
ALTER TABLE challenges ADD COLUMN archived BOOLEAN DEFAULT false;
ALTER TABLE user_goals ADD COLUMN archived BOOLEAN DEFAULT false;
ALTER TABLE user_high_freq_stats ADD COLUMN archived BOOLEAN DEFAULT false;
ALTER TABLE user_low_freq_stats ADD COLUMN archived BOOLEAN DEFAULT false;

-- Policies for users table
CREATE POLICY "Allow individual user access"
ON users
FOR SELECT USING (user_id = auth.uid() AND archived = false);

CREATE POLICY "Allow individual user update"
ON users
FOR UPDATE USING (user_id = auth.uid() AND archived = false);

CREATE POLICY "Allow admin access"
ON users
FOR ALL USING (role = 'admin');

-- Prevent deletion of users except by admin
CREATE POLICY "Prevent user deletion"
ON users
FOR DELETE TO PUBLIC
USING (role = 'admin');

-- Policies for items table
CREATE POLICY "Allow user to access own items"
ON items
FOR SELECT USING (user_id = auth.uid() AND archived = false);

CREATE POLICY "Allow user to modify own items"
ON items
FOR UPDATE USING (user_id = auth.uid() AND archived = false);

-- Prevent deletion of items except by admin
CREATE POLICY "Prevent item deletion"
ON items
FOR DELETE TO PUBLIC
USING (role = 'admin');

CREATE POLICY "Allow user to insert items"
ON items
FOR INSERT WITH CHECK (user_id = auth.uid());

-- Policies for outfits table
CREATE POLICY "Allow user to access own outfits"
ON outfits
FOR SELECT USING (user_id = auth.uid() AND archived = false);

CREATE POLICY "Allow user to modify own outfits"
ON outfits
FOR UPDATE USING (user_id = auth.uid() AND archived = false);

-- Prevent deletion of outfits except by admin
CREATE POLICY "Prevent outfit deletion"
ON outfits
FOR DELETE TO PUBLIC
USING (role = 'admin');

CREATE POLICY "Allow user to insert outfits"
ON outfits
FOR INSERT WITH CHECK (user_id = auth.uid());

-- Policies for outfit_items table
CREATE POLICY "Allow user to access own outfit items"
ON outfit_items
FOR SELECT USING (user_id = auth.uid() AND archived = false);

CREATE POLICY "Allow user to modify own outfit items"
ON outfit_items
FOR UPDATE USING (user_id = auth.uid() AND archived = false);

-- Prevent deletion of outfit items except by admin
CREATE POLICY "Prevent outfit item deletion"
ON outfit_items
FOR DELETE TO PUBLIC
USING (role = 'admin');

CREATE POLICY "Allow user to insert outfit items"
ON outfit_items
FOR INSERT WITH CHECK (user_id = auth.uid());

-- Policies for disliked_outfit_items table
CREATE POLICY "Allow user to access own disliked outfit items"
ON disliked_outfit_items
FOR SELECT USING (user_id = auth.uid() AND archived = false);

CREATE POLICY "Allow user to modify own disliked outfit items"
ON disliked_outfit_items
FOR UPDATE USING (user_id = auth.uid() AND archived = false);

-- Prevent deletion of disliked outfit items except by admin
CREATE POLICY "Prevent disliked outfit item deletion"
ON disliked_outfit_items
FOR DELETE TO PUBLIC
USING (role = 'admin');

CREATE POLICY "Allow user to insert disliked outfit items"
ON disliked_outfit_items
FOR INSERT WITH CHECK (user_id = auth.uid());

-- Policies for swaps table
CREATE POLICY "Allow user to access own swaps"
ON swaps
FOR SELECT USING (owner_id = auth.uid() OR new_owner_id = auth.uid() AND archived = false);

CREATE POLICY "Allow user to modify own swaps"
ON swaps
FOR UPDATE USING (owner_id = auth.uid() AND archived = false);

-- Prevent deletion of swaps except by admin
CREATE POLICY "Prevent swap deletion"
ON swaps
FOR DELETE TO PUBLIC
USING (role = 'admin');

CREATE POLICY "Allow user to insert swaps"
ON swaps
FOR INSERT WITH CHECK (owner_id = auth.uid() OR new_owner_id = auth.uid());

-- Policies for premium_services table
CREATE POLICY "Allow user to access own premium services"
ON premium_services
FOR SELECT USING (user_id = auth.uid() AND archived = false);

CREATE POLICY "Allow user to modify own premium services"
ON premium_services
FOR UPDATE USING (user_id = auth.uid() AND archived = false);

-- Prevent deletion of premium services except by admin
CREATE POLICY "Prevent premium service deletion"
ON premium_services
FOR DELETE TO PUBLIC
USING (role = 'admin');

CREATE POLICY "Allow user to insert premium services"
ON premium_services
FOR INSERT WITH CHECK (user_id = auth.uid());

-- Policies for challenges table
CREATE POLICY "Allow user to access own challenges"
ON challenges
FOR SELECT USING (user_id = auth.uid() AND archived = false);

CREATE POLICY "Allow user to modify own challenges"
ON challenges
FOR UPDATE USING (user_id = auth.uid() AND archived = false);

-- Prevent deletion of challenges except by admin
CREATE POLICY "Prevent challenge deletion"
ON challenges
FOR DELETE TO PUBLIC
USING (role = 'admin');

CREATE POLICY "Allow user to insert challenges"
ON challenges
FOR INSERT WITH CHECK (user_id = auth.uid());

-- Policies for user_goals table
CREATE POLICY "Allow user to access own goals"
ON user_goals
FOR SELECT USING (user_id = auth.uid() AND archived = false);

CREATE POLICY "Allow user to modify own goals"
ON user_goals
FOR UPDATE USING (user_id = auth.uid() AND archived = false);

-- Prevent deletion of user goals except by admin
CREATE POLICY "Prevent user goal deletion"
ON user_goals
FOR DELETE TO PUBLIC
USING (role = 'admin');

CREATE POLICY "Allow user to insert goals"
ON user_goals
FOR INSERT WITH CHECK (user_id = auth.uid());

-- Policies for user_high_freq_stats table
CREATE POLICY "Allow user to access own high freq stats"
ON user_high_freq_stats
FOR SELECT USING (user_id = auth.uid() AND archived = false);

CREATE POLICY "Allow user to modify own high freq stats"
ON user_high_freq_stats
FOR UPDATE USING (user_id = auth.uid() AND archived = false);

-- Prevent deletion of user high freq stats except by admin
CREATE POLICY "Prevent user high freq stat deletion"
ON user_high_freq_stats
FOR DELETE TO PUBLIC
USING (role = 'admin');

CREATE POLICY "Allow user to insert high freq stats"
ON user_high_freq_stats
FOR INSERT WITH CHECK (user_id = auth.uid());

-- Policies for user_low_freq_stats table
CREATE POLICY "Allow user to access own low freq stats"
ON user_low_freq_stats
FOR SELECT USING (user_id = auth.uid() AND archived = false);

CREATE POLICY "Allow user to modify own low freq stats"
ON user_low_freq_stats
FOR UPDATE USING (user_id = auth.uid() AND archived = false);

-- Prevent deletion of user low freq stats except by admin
CREATE POLICY "Prevent user low freq stat deletion"
ON user_low_freq_stats
FOR DELETE TO PUBLIC
USING (role = 'admin');

CREATE POLICY "Allow user to insert low freq stats"
ON user_low_freq_stats
FOR INSERT WITH CHECK (user_id = auth.uid());

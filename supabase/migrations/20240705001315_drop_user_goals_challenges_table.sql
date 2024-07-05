-- Drop all policies associated with challenges table
DROP POLICY IF EXISTS "Allow user to access own challenges" ON public.challenges;
DROP POLICY IF EXISTS "Allow user to delete own challenges" ON public.challenges;
DROP POLICY IF EXISTS "Allow user to insert own challenges" ON public.challenges;
DROP POLICY IF EXISTS "Allow user to modify own challenges" ON public.challenges;

-- Drop challenges table
DROP TABLE IF EXISTS public.challenges;

-- Drop all policies associated with user_goals table
DROP POLICY IF EXISTS "Allow user to access own goals" ON public.user_goals;
DROP POLICY IF EXISTS "Allow user to delete own goals" ON public.user_goals;
DROP POLICY IF EXISTS "Allow user to insert own goals" ON public.user_goals;
DROP POLICY IF EXISTS "Allow user to modify own goals" ON public.user_goals;

-- Drop user_goals table
DROP TABLE IF EXISTS public.user_goals;

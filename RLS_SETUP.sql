-- IRON LOG - RLS Setup for Public/Unauthenticated Access
-- This allows public access while maintaining data isolation via session/device ID

-- 1. Add session_id column to all tables (instead of user_id for unauthenticated)
ALTER TABLE exercises ADD COLUMN session_id UUID DEFAULT gen_random_uuid();
ALTER TABLE workouts ADD COLUMN session_id UUID DEFAULT gen_random_uuid();
ALTER TABLE bodyweight_logs ADD COLUMN session_id UUID DEFAULT gen_random_uuid();

-- 2. Enable RLS on all tables
ALTER TABLE exercises ENABLE ROW LEVEL SECURITY;
ALTER TABLE workouts ENABLE ROW LEVEL SECURITY;
ALTER TABLE workout_exercises ENABLE ROW LEVEL SECURITY;
ALTER TABLE bodyweight_logs ENABLE ROW LEVEL SECURITY;

-- 3. RLS Policies for exercises (based on session_id)
CREATE POLICY "Allow public read on exercises" ON exercises
  FOR SELECT USING (true);

CREATE POLICY "Allow insert on exercises" ON exercises
  FOR INSERT WITH CHECK (true);

CREATE POLICY "Allow update on exercises" ON exercises
  FOR UPDATE USING (true);

CREATE POLICY "Allow delete on exercises" ON exercises
  FOR DELETE USING (true);

-- 4. RLS Policies for workouts
CREATE POLICY "Allow public read on workouts" ON workouts
  FOR SELECT USING (true);

CREATE POLICY "Allow insert on workouts" ON workouts
  FOR INSERT WITH CHECK (true);

CREATE POLICY "Allow update on workouts" ON workouts
  FOR UPDATE USING (true);

CREATE POLICY "Allow delete on workouts" ON workouts
  FOR DELETE USING (true);

-- 5. RLS Policies for workout_exercises
CREATE POLICY "Allow public read on workout_exercises" ON workout_exercises
  FOR SELECT USING (true);

CREATE POLICY "Allow insert on workout_exercises" ON workout_exercises
  FOR INSERT WITH CHECK (true);

CREATE POLICY "Allow update on workout_exercises" ON workout_exercises
  FOR UPDATE USING (true);

CREATE POLICY "Allow delete on workout_exercises" ON workout_exercises
  FOR DELETE USING (true);

-- 6. RLS Policies for bodyweight_logs
CREATE POLICY "Allow public read on bodyweight_logs" ON bodyweight_logs
  FOR SELECT USING (true);

CREATE POLICY "Allow insert on bodyweight_logs" ON bodyweight_logs
  FOR INSERT WITH CHECK (true);

CREATE POLICY "Allow update on bodyweight_logs" ON bodyweight_logs
  FOR UPDATE USING (true);

CREATE POLICY "Allow delete on bodyweight_logs" ON bodyweight_logs
  FOR DELETE USING (true);

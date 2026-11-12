-- IRON LOG authenticated RLS setup
-- Run this entire script once in Supabase SQL Editor.

ALTER TABLE exercises
  ADD COLUMN IF NOT EXISTS user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE;

ALTER TABLE workouts
  ADD COLUMN IF NOT EXISTS user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE;

ALTER TABLE bodyweight_logs
  ADD COLUMN IF NOT EXISTS user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE;

ALTER TABLE workout_exercises
  ADD COLUMN IF NOT EXISTS sets_data jsonb NOT NULL DEFAULT '[]'::jsonb;

ALTER TABLE exercises ENABLE ROW LEVEL SECURITY;
ALTER TABLE workouts ENABLE ROW LEVEL SECURITY;
ALTER TABLE workout_exercises ENABLE ROW LEVEL SECURITY;
ALTER TABLE bodyweight_logs ENABLE ROW LEVEL SECURITY;

-- Remove policies created by earlier setup attempts.
DROP POLICY IF EXISTS "Allow public read on exercises" ON exercises;
DROP POLICY IF EXISTS "Allow insert on exercises" ON exercises;
DROP POLICY IF EXISTS "Allow update on exercises" ON exercises;
DROP POLICY IF EXISTS "Allow delete on exercises" ON exercises;
DROP POLICY IF EXISTS "Users manage own exercises" ON exercises;
DROP POLICY IF EXISTS "own exercises" ON exercises;

DROP POLICY IF EXISTS "Allow public read on workouts" ON workouts;
DROP POLICY IF EXISTS "Allow insert on workouts" ON workouts;
DROP POLICY IF EXISTS "Allow update on workouts" ON workouts;
DROP POLICY IF EXISTS "Allow delete on workouts" ON workouts;
DROP POLICY IF EXISTS "Users manage own workouts" ON workouts;
DROP POLICY IF EXISTS "own workouts" ON workouts;

DROP POLICY IF EXISTS "Allow public read on workout_exercises" ON workout_exercises;
DROP POLICY IF EXISTS "Allow insert on workout_exercises" ON workout_exercises;
DROP POLICY IF EXISTS "Allow update on workout_exercises" ON workout_exercises;
DROP POLICY IF EXISTS "Allow delete on workout_exercises" ON workout_exercises;
DROP POLICY IF EXISTS "Users manage own workout details" ON workout_exercises;
DROP POLICY IF EXISTS "own workout exercises" ON workout_exercises;

DROP POLICY IF EXISTS "Allow public read on bodyweight_logs" ON bodyweight_logs;
DROP POLICY IF EXISTS "Allow insert on bodyweight_logs" ON bodyweight_logs;
DROP POLICY IF EXISTS "Allow update on bodyweight_logs" ON bodyweight_logs;
DROP POLICY IF EXISTS "Allow delete on bodyweight_logs" ON bodyweight_logs;
DROP POLICY IF EXISTS "Users manage own bodyweight" ON bodyweight_logs;
DROP POLICY IF EXISTS "own bodyweight" ON bodyweight_logs;

CREATE POLICY "authenticated users own exercises"
  ON exercises FOR ALL TO authenticated
  USING (user_id = auth.uid())
  WITH CHECK (user_id = auth.uid());

CREATE POLICY "authenticated users own workouts"
  ON workouts FOR ALL TO authenticated
  USING (user_id = auth.uid())
  WITH CHECK (user_id = auth.uid());

CREATE POLICY "authenticated users own bodyweight"
  ON bodyweight_logs FOR ALL TO authenticated
  USING (user_id = auth.uid())
  WITH CHECK (user_id = auth.uid());

CREATE POLICY "authenticated users own workout exercises"
  ON workout_exercises FOR ALL TO authenticated
  USING (
    EXISTS (
      SELECT 1
      FROM workouts
      WHERE workouts.id = workout_exercises.workout_id
        AND workouts.user_id = auth.uid()
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1
      FROM workouts
      WHERE workouts.id = workout_exercises.workout_id
        AND workouts.user_id = auth.uid()
    )
  );

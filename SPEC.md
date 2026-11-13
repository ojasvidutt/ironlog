# Workout Tracker - Specification

## Project Overview
- **Name**: Iron Log
- **Type**: Single-page web application
- **Core Functionality**: Minimalist workout tracking with exercise library, daily workouts (sets/reps/rest), and bodyweight logging
- **Target Users**: Self-driven fitness enthusiasts who want a distraction-free, old-school tracking tool

## Tech Stack
- **Frontend**: Vanilla HTML/CSS/JS in single file
- **Backend**: Supabase (free PostgreSQL + auto REST API)
- **No build step required**

## UI/UX Specification

### Visual Design - "Terminal Ledger" Aesthetic

**Color Palette**
- Background: `#0a0a0a` (near black)
- Surface: `#141414` (slightly lighter for cards)
- Border: `#2a2a2a` (subtle dividers)
- Primary text: `#ffb000` (amber - CRT terminal feel)
- Secondary text: `#888888` (muted gray)
- Accent: `#00ff88` (green for success/positive)
- Danger: `#ff4444` (red for delete/danger)
- Input background: `#0d0d0d`

**Typography**
- Font family: `"IBM Plex Mono", "Courier New", monospace`
- Headings: 1.2rem, uppercase, letter-spacing: 0.1em
- Body: 0.9rem
- Small/labels: 0.75rem

**Spacing**
- Base unit: 8px
- Card padding: 16px
- Section gaps: 24px
- Input padding: 8px 12px

**Visual Effects**
- No shadows, no gradients
- Simple 1px solid borders
- No animations except fade-in on load (150ms)
- Cursor: pointer on interactive elements
- Focus states: outline 1px solid #ffb000

### Layout Structure

**Header**
- App title "IRON LOG" centered
- Subtitle: "// WORKOUT TRACKER" in secondary color
- Minimal, takes ~60px height

**Navigation**
- Tab-based navigation: [EXERCISES] [WORKOUT] [BODYWEIGHT] [HISTORY]
- Active tab: amber background with black text
- Inactive tabs: transparent with amber text
- Simple underline indicator

**Content Area**
- Max-width: 600px, centered
- Cards for each section
- Consistent card styling with border

### Components

**Tab Navigation**
- Horizontal tabs at top
- States: default (amber text), hover (slightly brighter), active (amber bg, black text)

**Input Fields**
- Dark background (#0d0d0d)
- 1px border (#2a2a2a)
- Amber text
- Placeholder text: #555
- Focus: border changes to #ffb000

**Buttons**
- Primary: amber background, black text, uppercase
- Secondary: transparent, amber border, amber text
- Danger: transparent, red border, red text
- Padding: 8px 16px
- No hover animations, just color shift

**Cards**
- Background: #141414
- Border: 1px solid #2a2a2a
- Padding: 16px
- Margin-bottom: 16px

**Tables/Lists**
- Simple bordered rows
- Alternating subtle backgrounds (#141414 / #0d0d0d)
- Right-aligned numbers

**Date Display**
- Format: "2026-11-12" (ISO-style, no frills)
- Used in workout cards and history

## Functionality Specification

### 1. Exercise Library (Exercises Tab)

**Features**
- Display list of all custom exercises
- Add new exercise (name input + Add button)
- Delete exercise (X button, with confirmation)
- Exercises are alphabetically sorted

**Data Flow**
- Fetch exercises from Supabase on load
- Add: POST to `/exercises` table
- Delete: DELETE from `/exercises` table

### 2. Daily Workout (Workout Tab)

**Features**
- Date picker (defaults to today)
- Exercise selector dropdown (populated from exercise library)
- Add exercise to workout:
  - Select exercise
  - Enter sets (number)
  - Enter reps (number)
  - Enter rest time in seconds (number)
  - Optional notes
- Display current workout with all added exercises
- Each exercise shows: name, sets × reps, rest: Xs, notes
- Remove exercise from workout (X button)
- Save workout button
- Clear workout button

**Data Flow**
- Workout stored in local state until saved
- On save: POST to `/workouts` table, then POST each exercise to `/workout_exercises`
- Workout exercises link to exercises table

### 3. Bodyweight Tracking (Bodyweight Tab)

**Features**
- Today's weight input (decimal, e.g., 175.5)
- Save button
- Display last 30 days of weight logs
- Show trend: last weight vs 7-day average
- Delete individual log entry

**Data Flow**
- POST to `/bodyweight_logs` table
- DELETE from `/bodyweight_logs` table
- GET with order by date desc, limit 30

### 4. History (History Tab)

**Features**
- Personal records list for every exercise with a saved set
- Each record is based on the highest weight lifted, and shows the workout date, weight, and reps from that set
- List past workouts by date (newest first)
- Each entry shows: date, number of exercises, expandable details
- Click to expand and see exercise details (sets, reps, rest)
- Delete workout option

**Data Flow**
- Personal records are derived from saved workout exercise sets; no duplicate record data is stored
- GET from `/workouts` with join to `/workout_exercises` and `/exercises`
- DELETE from `/workouts` (cascades to workout_exercises)

### 5. Supabase Setup (User Configured)

**Configuration**
- Supabase URL and anon key stored in config section
- User needs to create free account at supabase.com
- Instructions provided in app for setup

## Database Schema

```sql
-- Run these in Supabase SQL Editor

-- Exercises table
CREATE TABLE exercises (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Workouts table
CREATE TABLE workouts (
  id SERIAL PRIMARY KEY,
  date DATE NOT NULL,
  notes TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Workout exercises junction table
CREATE TABLE workout_exercises (
  id SERIAL PRIMARY KEY,
  workout_id INTEGER REFERENCES workouts(id) ON DELETE CASCADE,
  exercise_id INTEGER REFERENCES exercises(id),
  sets INTEGER,
  reps INTEGER,
  rest_seconds INTEGER,
  notes TEXT
);

-- Bodyweight logs
CREATE TABLE bodyweight_logs (
  id SERIAL PRIMARY KEY,
  date DATE NOT NULL UNIQUE,
  weight DECIMAL(5,1) NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Enable RLS (optional - for now keep open for development)
```

## Acceptance Criteria

1. ✅ App loads with terminal/old-school aesthetic (dark, amber text, monospace)
2. ✅ Can add exercises to library
3. ✅ Can delete exercises from library
4. ✅ Can create a workout with multiple exercises (sets, reps, rest)
5. ✅ Can save workout to Supabase
6. ✅ Can log bodyweight daily
7. ✅ Can view workout history
8. ✅ All data persists in Supabase
9. ✅ Works offline for viewing after initial load (future enhancement)
10. ✅ Mobile-responsive (stacks naturally)
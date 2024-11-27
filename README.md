# Dimension Modeling for Actors Data

This document outlines the approach for modeling actors' data with cumulative updates and Slowly Changing Dimensions (SCD) handling.

## 1. Actors Table

The `actors` table is designed to store yearly information about actors, including their films, quality classification, and activity status. It supports tracking historical changes by using custom data types and enumerations to classify actors based on their performance metrics.

### Key Features:
- Maintains a record of an actor's films over the years.
- Dynamically assigns quality classifications based on average film ratings.
- Tracks whether the actor was active in a given year.

---

## 2. Cumulative Table Generation

This query consolidates data for actors from the previous year and the current year into the `actors` table. It uses:
- **Data aggregation** for current year films and ratings.
- **Classification rules** for assigning quality categories:
  - `star`, `good`, `average`, or `bad` based on average ratings.
- **Full outer join** to merge historical and current data.

### Key Outputs:
- Updated film lists for actors, combining historical and new data.
- Revised quality classifications based on the latest ratings.
- Updated `is_active` flags to indicate the actor's current status.

---

## 3. Actors History SCD Table

The `actors_history_scd` table is used to track historical changes in actors' activity and quality classification over time. It follows the Slowly Changing Dimension (SCD) Type 2 methodology by storing:
- Start and end dates for each record.
- Snapshots of changes in key attributes (`is_active` and `quality_class`).

### Key Features:
- Enables historical trend analysis.
- Records distinct periods of changes in actor attributes.

---

## 4. Backfill Query for SCD

The backfill query initializes the `actors_history_scd` table by:
1. **Detecting Changes**:
   - Identifies differences in `quality_class` or `is_active` between consecutive years.
2. **Streak Identification**:
   - Groups unchanged periods into streaks to minimize redundant records.
3. **Generating Historical Records**:
   - Assigns start and end dates for each streak.

### Key Outputs:
- Fully populated historical data up to the current year.
- Continuous periods of unchanged attributes are grouped for efficiency.

---

## 5. Incremental Query for SCD

The incremental query updates the `actors_history_scd` table for the latest year by:
1. **Categorizing Records**:
   - Unchanged: Retains the previous record.
   - Changed: Closes the previous record and starts a new one.
   - New: Inserts new records for actors with no previous data.
2. **Managing SCD Updates**:
   - Ensures seamless integration of new data while preserving historical integrity.

### Key Outputs:
- Updated historical records reflecting attribute changes.
- Accurate tracking of actors' activity and quality classification over time.

---

## Summary

This dimension modeling approach ensures:
- **Comprehensive Historical Tracking**:
  - Maintains detailed snapshots of actors' careers.
- **SCD Type 2 Implementation**:
  - Efficiently handles changes in key attributes across years.
- **Dynamic Quality Classification**:
  - Reflects real-time updates based on performance metrics.

### Applications:
- Analytical use cases such as trend analysis and performance monitoring.
- Effective management of slowly changing attributes in a data warehouse.

/*
  # Rename restaurants table to public.restaurants

  1. Changes
    - Rename table from "restaurants" to "public.restaurants"
*/

ALTER TABLE IF EXISTS restaurants 
SET SCHEMA public;
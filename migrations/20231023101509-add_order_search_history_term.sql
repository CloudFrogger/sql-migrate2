
-- +migrate Up
ALTER TABLE orders_results.orders_search_history ADD search_term varchar NOT NULL DEFAULT '';

-- +migrate Down
ALTER TABLE orders_results.orders_search_history DROP COLUMN search_term;

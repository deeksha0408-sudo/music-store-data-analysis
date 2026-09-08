# Music Store Data Analysis

SQL analysis of a digital music store database using PostgreSQL. This project contains queries that answer business questions across three difficulty levels.

## Dataset

The dataset is a digital music store database (based on the Chinook dataset) containing:

| Table | Description |
|-------|-------------|
| `album` | Album catalog information |
| `artist` | Artist names |
| `customer` | Customer details |
| `employee` | Employee details |
| `genre` | Music genres |
| `invoice` | Invoice header records |
| `invoice_line` | Invoice line items |
| `media_type` | Media formats |
| `playlist` | Playlists |
| `playlist_track` | Playlist–track mapping |
| `track` | Song/track details |

All CSV data files are located in the [`Used Dataset`](Used%20Dataset/) folder. See [`schema_diagram.png`](schema_diagram.png) for the database relationships.

## Queries

### Question Set 1 - Easy
1. Senior-most employee based on job title
2. Country with the most invoices
3. Top 3 values of total invoice
4. City with the best customers (highest sum of invoice totals)
5. Best customer (most money spent)

### Question Set 2 - Moderate
1. Rock music listeners (email, first name, last name)
2. Top 10 artists with the most Rock tracks
3. Tracks longer than the average song length

### Question Set 3 - Advanced
1. Amount spent by each customer on the best-selling artist
2. Most popular genre for each country
3. Customer who spent the most on music in each country (using window functions)

## Usage

Load the CSV files into a PostgreSQL database using the schema defined in [`schema_diagram.png`](schema_diagram.png), then run the queries in [`music_store_data_analysis.sql`](music_store_data_analysis.sql).
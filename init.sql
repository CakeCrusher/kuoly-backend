CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
DROP TABLE IF EXISTS listing_labels;
DROP TABLE IF EXISTS labels;
DROP TABLE IF EXISTS links;
DROP TABLE IF EXISTS listings;
DROP TABLE IF EXISTS catalogues;
DROP TABLE IF EXISTS metrics;
DROP TABLE IF EXISTS feedback;

CREATE TABLE catalogues (
  id UUID DEFAULT uuid_generate_v4(),
  edit_id UUID DEFAULT uuid_generate_v4(),
  user_id TEXT NOT NULL,
  status TEXT DEFAULT 'public' NOT NULL,
  title TEXT DEFAULT 'Untitled List',
  description TEXT,
  views INT DEFAULT 0 NOT NULL, 
  header_image_url TEXT,
  header_color TEXT DEFAULT '#c9042c',
  author TEXT,
  profile_picture_url TEXT,
  event_date DATE,
  location TEXT,
  created TIMESTAMP DEFAULT NOW(),
  updated TIMESTAMP DEFAULT NOW(),
  PRIMARY KEY (id)
);

CREATE TABLE listings (
  id UUID DEFAULT uuid_generate_v4(),
  catalogue_id UUID NOT NULL,
  name TEXT,
  link_url TEXT,
  image_url TEXT,
  description TEXT,
  ordering FLOAT NOT NULL DEFAULT 0,
  show_price BOOLEAN DEFAULT true,
  price NUMERIC,
  created TIMESTAMP DEFAULT NOW(),
  updated TIMESTAMP DEFAULT NOW(),
  PRIMARY KEY (id),
  FOREIGN KEY (catalogue_id) REFERENCES catalogues (id) ON DELETE CASCADE
);

CREATE TABLE links (
  id UUID DEFAULT uuid_generate_v4(),
  listing_id UUID NOT NULL,
  url TEXT NOT NULL,
  title TEXT,
  created TIMESTAMP DEFAULT NOW(),
  updated TIMESTAMP DEFAULT NOW(),
  PRIMARY KEY (id),
  FOREIGN KEY (listing_id) REFERENCES listings (id) ON DELETE CASCADE
);

CREATE TABLE labels (
  id UUID DEFAULT uuid_generate_v4(),
  catalogue_id UUID NOT NULL,
  name TEXT NOT NULL,
  link_url TEXT,
  ordering FLOAT NOT NULL,
  is_private BOOLEAN DEFAULT false,
  created TIMESTAMP DEFAULT NOW(),
  updated TIMESTAMP DEFAULT NOW(),
  PRIMARY KEY (id),
  FOREIGN KEY (catalogue_id) REFERENCES catalogues (id) ON DELETE CASCADE
);

CREATE TABLE listing_labels (
  id UUID DEFAULT uuid_generate_v4(),
  label_id UUID NOT NULL,
  listing_id UUID NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (label_id) REFERENCES labels (id) ON DELETE CASCADE,
  FOREIGN KEY (listing_id) REFERENCES listings (id) ON DELETE CASCADE
);

CREATE TABLE metrics (
  id UUID DEFAULT uuid_generate_v4(),
  type TEXT NOT NULL,
  user_id TEXT,
  operation_name TEXT,
  operation_type TEXT,
  operation_variables TEXT,
  navigate_to TEXT,
  click_on TEXT,
  created TIMESTAMP DEFAULT NOW(),
  PRIMARY KEY (id)
);

CREATE TABLE feedback (
  id UUID DEFAULT uuid_generate_v4(),
  user_id TEXT NOT NULL,
  message TEXT NOT NULL,
  email TEXT,
  created TIMESTAMP DEFAULT NOW(),
  PRIMARY KEY (id)
);

INSERT INTO catalogues (
  user_id
) VALUES (
  '6a3a2967-0258-4caf-8fef-f844c060b2f2'
);

INSERT INTO catalogues (
  id,
  edit_id,
  user_id,
  title,
  description,
  author,
  profile_picture_url,
  header_image_url
) VALUES (
  'f470498b-71ff-470a-8c61-1fc4101449dd',
  'bfb04418-6c9f-42c7-a97f-2f9ce8cf3e07',
  '6a3a2967-0258-4caf-8fef-f844c060b2f2',
  'title1',
  'Join an Empire State Building ambassador for this historic tour of the world`s most famous skyscraper, plus you`ll bring home a limited edition 90th anniversary tote bag! Buy Tickets. Sunri',
  'Sebastian',
  'https://storage.googleapis.com/givespace-pictures/profile1647721041622.PNG',
  'https://storage.googleapis.com/givespace-pictures/Capture1648341244550.PNG'
); 

INSERT INTO labels (
  id,
  catalogue_id,
  name,
  ordering
) VALUES (
  'd5a998be-205c-4a5e-8f41-05f808cdc9e1',
  'f470498b-71ff-470a-8c61-1fc4101449dd',
  'label0',
  0
), (
  'fbe5c847-5419-487a-a803-e7b2ca9bfa7e',
  'f470498b-71ff-470a-8c61-1fc4101449dd',
  'label1',
  1
), (
  '51692a78-c744-4f8e-a2c5-d4a422fc657d',
  'f470498b-71ff-470a-8c61-1fc4101449dd',
  'label2',
  2
), (
  '35b2a996-ab59-4dcd-9885-9a2a54d1608c',
  'f470498b-71ff-470a-8c61-1fc4101449dd',
  'label3',
  3
);

INSERT INTO listings (
  id,
  catalogue_id,
  name,
  ordering
) VALUES (
  '7f0251d2-0d33-457a-89ef-5a0e6a5c36be',
  'f470498b-71ff-470a-8c61-1fc4101449dd',
  'item0',
  0
), (
  '261a378d-97d7-46fa-a5c2-83c99e4fa7b6',
  'f470498b-71ff-470a-8c61-1fc4101449dd',
  'item1',
  1
), (
  '262a378d-97d7-46fa-a5c2-83c99e4fa7b6',
  'f470498b-71ff-470a-8c61-1fc4101449dd',
  'item2',
  2
), (
  '1f0251d2-0d33-457a-89ef-5a0e6a5c36b1',
  'f470498b-71ff-470a-8c61-1fc4101449dd',
  'item3',
  3
), (
  '2f0251d2-0d33-457a-89ef-5a0e6a5c36b2',
  'f470498b-71ff-470a-8c61-1fc4101449dd',
  'item4',
  4
), (
  '3f0251d2-0d33-457a-89ef-5a0e6a5c36b3',
  'f470498b-71ff-470a-8c61-1fc4101449dd',
  'item5',
  5
), (
  '4f0251d2-0d33-457a-89ef-5a0e6a5c36b4',
  'f470498b-71ff-470a-8c61-1fc4101449dd',
  'item6',
  6
), (
  '5f0251d2-0d33-457a-89ef-5a0e6a5c36b5',
  'f470498b-71ff-470a-8c61-1fc4101449dd',
  'item7',
  7
);

INSERT INTO links (
  id,
  listing_id,
  url,
  title
) VALUES (
  'a1fdae29-9a83-46f0-b0e8-302e05408c83',
  '7f0251d2-0d33-457a-89ef-5a0e6a5c36be',
  'https://link0.com',
  'link0'
  
), (
  '59dece83-1a85-4576-8a53-cf9bc17c9acd',
  '7f0251d2-0d33-457a-89ef-5a0e6a5c36be',
  'https://link1.com',
  'link1'
), (
  '59dece83-1a85-4576-8a53-cf9bc17c9ac2',
  '7f0251d2-0d33-457a-89ef-5a0e6a5c36be',
  'https://link1.com',
  'link2'
), (
  '59dece83-1a85-4576-8a53-cf9bc17c9ac3',
  '7f0251d2-0d33-457a-89ef-5a0e6a5c36be',
  'https://link1.com',
  'link3'
), (
  '59dece83-1a85-4576-8a53-cf9bc17c9ac4',
  '7f0251d2-0d33-457a-89ef-5a0e6a5c36be',
  'https://link1.com',
  'link4'
);

INSERT INTO listing_labels (
  id,
  label_id,
  listing_id
) VALUES (
  '33ca33d3-8fd6-49ee-8821-de2cc9cc5ba8',
  'd5a998be-205c-4a5e-8f41-05f808cdc9e1',
  '7f0251d2-0d33-457a-89ef-5a0e6a5c36be'
), (
  'e70da965-6260-4b72-a736-e5f9b9246ccf',
  '51692a78-c744-4f8e-a2c5-d4a422fc657d',
  '7f0251d2-0d33-457a-89ef-5a0e6a5c36be'
), (
  '103498aa-7c47-4c7c-ac10-7c01a4dfc3ce',
  '51692a78-c744-4f8e-a2c5-d4a422fc657d',
  '261a378d-97d7-46fa-a5c2-83c99e4fa7b6'
);

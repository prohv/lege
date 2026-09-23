CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name text not null,
    username text unique not null,
    created_at timestamptz not null DEFAULT now(),
    updated_at timestamptz not null DEFAULT now()
);

CREATE Type processing_state as enum (
    'uploading', 'saved', 'processing_text', 'processed_text', 'upload_failed', 'processing_failed'  
);

CREATE TABLE books (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid not null references users(id) on delete cascade,
    isbn_id text,
    title text not null DEFAULT 'My Book',
    author text,
    tag text,
    num_of_chapters int not null DEFAULT 0,
    file_storage_key text not null,
    processing_state processing_state not null default 'uploading',
    created_at timestamptz not null DEFAULT now(),
    updated_at timestamptz not null DEFAULT now()
);

CREATE Type condensed_chapter_state as enum (
    'not_condensed', 'condensing', 'condensed', 'failed_condensing'  
);

CREATE TABLE chapters (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    book_id uuid not null references books(id) on delete cascade,
    chapter_num int default 1,
    chapter_title text not null,
    chapter_subtitle text,
    chapter_content text not null,
    created_at timestamptz not null DEFAULT now(),
    updated_at timestamptz not null DEFAULT now()
);

CREATE Type condense_level as enum (
    '20', '40', '60', '80'
);

CREATE TABLE condensed_chapters (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    chapter_id uuid not null references chapters(id) on delete cascade,
    condense_level condense_level not null,
    condense_content text,
    condensed_chapter_state condensed_chapter_state default 'not_condensed',
    UNIQUE (chapter_id, condense_level),
    created_at timestamptz not null DEFAULT now(),
    updated_at timestamptz not null DEFAULT now()    
);

CREATE TABLE reading_progress (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid not null references users(id) on delete cascade,
    condensed_chapter_id uuid not null references condensed_chapters(id) on delete cascade,
    on_para int not null default 0,
    updated_at timestamptz not null default now()
);





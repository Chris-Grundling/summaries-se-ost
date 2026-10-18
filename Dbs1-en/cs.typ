#import "../lib.typ": *
#import fletcher.shapes: brace, ellipse, pill
#import "./info.typ": info

#show: cheatsheet.with(..info)

#let tf = c => table.cell(fill: colors.comment, c)
#let ts = c => table.cell(fill: colors-l.green, c)
#let tc = b => table.cell(fill: colors-l.red)[#b]
#let sqltbl = (..body) => {
  set text(font: code-font)
  set table(stroke: 0.07em)
  set table.cell(align: center)
  table(..body)
}
#let node = fletcher.node.with(inset: 2pt)

// FIXME: shared doc
#{
  let node = node.with(inset: 3pt)
  let edge = edge.with(label-side: right)
  let gr = colors.green
  let yl = colors.yellow.darken(10%)
  set text(size: 5pt)
  diagram(
    node-stroke: 0.9pt,
    edge-stroke: 0.9pt,
    mark-scale: 40%,
    spacing: (2em, 3em),
    node(
      (0, 0),
      text(fill: colors.purple)[Information\ requirements],
      name: <info>,
      shape: pill,
      stroke: colors.purple,
    ),
    node(
      (2, 0),
      text(fill: colors.red)[Data processing\ requirements],
      name: <daten>,
      shape: pill,
      stroke: colors.red,
    ),
    node(
      (2, 2),
      text(fill: colors.darkblue)[DBMS\ characteristics],
      name: <dbms>,
      shape: pill,
      stroke: colors.darkblue,
    ),
    node(
      (2.1, 3),
      text(fill: gr)[Hardware/OS\ characteristics],
      name: <hw>,
      shape: pill,
      stroke: gr,
    ),
    node(
      (1, 0),
      [Requirements\ analysis],
      name: <anal>,
      fill: colors-l.blue,
      stroke: colors-l.blue,
    ),
    edge("->", text(
      style: "italic",
      fill: colors.black,
    )[Requirements\ specification]),
    node(
      (1, 1),
      [Conceptual\ DB design],
      name: <konz>,
      fill: colors-l.blue,
      stroke: colors-l.blue,
    ),
    edge("->", text(
      style: "italic",
      fill: colors.black,
    )[Conceptual\ data model]),
    node(
      (1, 2),
      [Logical\ DB design],
      name: <log>,
      fill: colors-l.blue,
      stroke: colors-l.blue,
    ),
    edge("->", text(
      style: "italic",
      fill: colors.black,
    )[Logical\ data model]),
    node(
      (1, 3),
      [Physical\ design],
      name: <phys>,
      fill: colors-l.blue,
      stroke: colors-l.blue,
    ),
    edge("->", text(
      style: "italic",
      fill: colors.black,
    )[\ \ Physical\ data model\ (Schema)]),
    node(
      (1, 4),
      [\ ],
      fill: colors-l.blue,
      stroke: colors-l.blue,
      shape: circle,
      inset: 1pt,
    ),
    node(
      (0, 1),
      text(fill: yl)[(1) UML\ class diagram],
      name: <uml>,
      stroke: none,
    ),
    node(
      (0, 2),
      text(fill: yl)[(2) Relational\ notation],
      name: <rel>,
      stroke: none,
    ),
    node(
      (0, 3),
      text(fill: yl)[(3) DB schema\ (PG SQL)],
      name: <sql>,
      stroke: none,
    ),
    edge(<info>, <anal>, "-|>", stroke: colors.purple),
    edge((0.2, 0), (0.2, 0.9), (1, 0.9), "-|>", stroke: colors.purple),
    edge(<daten>, <anal>, "-|>", stroke: colors.red),
    edge((1.5, 0), (1.5, 0.9), (1, 0.9), "-|>", stroke: colors.red),
    edge((1.5, 0), (1.5, 1.9), (1, 1.9), "-|>", stroke: colors.red),
    edge((1.5, 0), (1.5, 2.9), (1, 2.9), "-|>", stroke: colors.red),
    edge(<dbms>, <log>, "-|>", stroke: colors.darkblue),
    edge((1.6, 2), (1.6, 3), (1, 3), "-|>", stroke: colors.darkblue),
    edge(<hw>, <phys>, "-|>", shift: 0.1, stroke: gr),
    edge(<uml>, <konz>, "-|>", stroke: yl),
    edge(<rel>, <log>, "-|>", stroke: yl),
    edge(<sql>, <phys>, "-|>", stroke: yl),
  )
}

= Glossary

#deftblge(
  [Impedance-Mismatch],
  [Impedance-Mismatch],
  [Mismatch between data structures at the application and database levels],
  [System-/Datenkatalog],
  [System/data catalog],
  [Contains metadata about database objects, e.g. tables and schemas.],
  [Datenbankschema],
  [Database schema],
  [Structure of a database describing the organization of data and relationships.],
  [Datenbasis],
  [Data store],
  [The physical storage location],
  [Surrogate Key],
  [Surrogate Key],
  [Artificially generated PK],
  [Referentielle\ Integrität],
  [Referential\ integrity],
  [A foreign key must reference a value in the referenced table or NULL],
  [Datenunabhängigkeit],
  [Data independence],
  [Ability to change data in a DB without having to change applications],
  [Data Pages],
  [Data Pages],
  [Smallest data storage units of a DB],
  [Heaps],
  [Heaps],
  [Unsorted data organization],
  [Semantische\ Integrität],
  [Semantic\ integrity],
  [Data is correct in both syntax and content, especially after transactions],
  [Data dictionary],
  [Data dictionary],
  [Central collection of metadata about the data in the DBMS],
)
= Database models
#deftblge(
  [Hierarchisch],
  [Hierarchical],
  [Data is arranged in a tree-like structure],
  [Netzwerk],
  [Network],
  [More flexible structure than hierarchical; allows multiple paths between entities],
  [Objektorientiert],
  [Object-oriented],
  [Stores data and its behavior as objects],
  [Objektrelational],
  [Object-relational],
  [Combines object-oriented + relational principles],
  [Relational],
  [Relational],
  [Stores data in tables (relations) and manages relationships using keys],
)
#let app = (..b) => node(shape: pill, inset: 3pt, ..b)
#grid(
  columns: (auto, auto, auto),
  [
    1-Tier \
    #diagram(
      node((0, 0.3), "Device", stroke: none),
      app((0, 1), "Application"),
      edge("<->"),
      app((0, 3), [Local\ database]),
      node(enclose: ((0, 0), (0, 3))),
    )
  ],
  [
    2-Tier \
    #diagram(
      node((0, 0.3), "Client", stroke: none, name: <cl>),
      app((0, 1), "Application", name: <app>),
      edge("<-"),
      node((0, 2), "Network", stroke: none),
      edge("->"),
      node((0, 3), "Server", stroke: none, name: <srv>),
      app((0, 3.7), "Database", name: <db>),
      node(enclose: (<cl>, <app>)),
      node(enclose: (<srv>, <db>)),
    )
  ],
  [
    3-Tier \
    #diagram(
      node((0, 0.3), "Client", stroke: none),
      app((0, 1), "Application"),
      edge("<-"),
      node((0, 2), "Network", stroke: none),
      edge("->"),
      node((0, 3), "Server", stroke: none),
      app((0, 3.7), "Application server", name: <srv>),
      app((0, 5), "Database", name: <db>),
      edge(<srv>, <db>, "<->"),
      node(enclose: ((0, 0.3), (0, 1))),
      node(enclose: ((0, 3), <srv>, <db>)),
    )
  ],
)
== DataBase System (DBS) \
Consists of a DBMS and data stores \
== DataBase Management System (DBMS) \
#grid(
  columns: (auto, auto),
  [
    - `(A)` Transactions
    - `(C)` Consistency
    - `(I)` Multi-user operation
    - `(D)` Large amounts of data
    - `(D)` Security
  ],
  [
    - Data types
    - Query language
    - Backup & Recovery
    - Freedom from redundancy
    - Encapsulation
  ],
)
// #colbreak()
== ANSI model \
/ Logical level: Logical structure of the data \
/ Internal level: Storage structures, defined by the internal schema (relationships, tables, etc.) \
/ External level: A user class's view of a subset of the DB, defined by an external schema \
/ Mapping: A more or less complex mapping is required between the levels \
== Relational model \
PKs are #underline("underlined"), FKs are #text(style: "italic", "italicized") \
tabellenname ( \
#h(1em) #underline("id") SERIAL PRIMARY KEY, \
#h(1em) grade DECIMAL(2,1) NOT NULL, \
#h(1em) #text(style: "italic", "fk") INT FOREIGN KEY REFERENCES t2, \
#h(1em) u VARCHAR(9) DEFAULT CURRENT_USER, \
); \
= Unified Modeling Language (UML) \
#let nw2 = (width: 52pt, height: 6pt)
#let nw3 = (width: 1pt, height: 6pt)
#let nt2 = t => text(
  size: 5pt,
)[#t]
#diagram(
  node-stroke: none,
  spacing: (16pt, 1em),
  node(..nw2, (1, 1), nt2("One"), name: <fst>),
  node(..nw3, (2, 1), "", name: <fst2>),
  edge(<fst>, <fst2>, "1-"),
  node(..nw2, (3, 1), nt2("Many"), name: <snd>),
  node(..nw3, (4, 1), "", name: <snd2>),
  edge(<snd>, <snd2>, "n-"),

  node(..nw2, (1, 2), nt2[One (mandatory)], name: <trd>),
  node(..nw3, (2, 2), "", name: <trd2>),
  edge(<trd>, <trd2>, "1!-"),
  node(..nw2, (3, 2), nt2[Many (at least 1)], name: <frt>),
  node(..nw3, (4, 2), "", name: <frt2>),
  edge(<frt>, <frt2>, "n!-"),

  node(..nw2, (1, 3), nt2[0 or one], name: <fth>),
  node(..nw3, (2, 3), "", name: <fth2>),
  edge(<fth>, <fth2>, "1?-"),
  node(..nw2, (3, 3), nt2[0 or many], name: <sxt>),
  node(..nw3, (4, 3), "", name: <sxt2>),
  edge(<sxt>, <sxt2>, "n?-"),

  node(..nw2, (1, 4), nt2("Association"), name: <nnt>),
  node(..nw3, (2, 4), "", name: <nnt2>),
  edge(<nnt>, <nnt2>, "straight-"),
  node(..nw2, (3, 4), nt2("Composition"), name: <ttt>),
  node(..nw3, (4, 4), "", name: <ttt2>),
  edge(<ttt>, <ttt2>, "composition-"),

  node(..nw2, (1, 5), nt2("Aggregation"), name: <ele>),
  node(..nw3, (2, 5), "", name: <ele2>),
  edge(<ele>, <ele2>, "aggregation-"),
  node(..nw2, (3, 5), nt2("Inheritance"), name: <twt>),
  node(..nw3, (4, 5), "", name: <twt2>),
  edge(<twt>, <twt2>, "inheritance-"),
)

/ Complete: All subclasses are defined \
/ Incomplete: Additional subclasses are allowed \
/ Disjoint: An instance of exactly one subclass \
/ Overlapping: Can be an instance of multiple overlapping subclasses \
= Normalization \
/ 1NF: Atomic attribute values: split _track_ \
#grid(
  columns: (5fr, auto, 6fr),
  sqltbl(
    columns: (1fr, 6fr),
    tf[id],
    [track],
    tf[1],
    tc[Fugazi: Song \#1],
  ),
  $=>$,
  sqltbl(
    columns: (1fr, 3fr, 3fr),
    tf[id],
    [interpret],
    [titel],
    tf[1],
    [Fugazi],
    [Song \#1],
  ),
)
/ 2NF: Non-key attributes fully depend on the key.
If the PK is atomic, 2NF is satisfied. In the example, not all PK attributes are needed to uniquely identify _album_ \
#sqltbl(
  columns: (1fr, 1fr, 1fr, 1fr),
  tf[track],
  tf[cd_id],
  [album],
  [titel],
  tf[1],
  tc[1],
  tc[Repeater],
  [Turnover],
  tf[2],
  tc[1],
  tc[Repeater],
  [Song \#1],
)
#grid(
  columns: (2fr, 1fr),
  [$=>$ track], [cd],
  sqltbl(
    columns: (1fr, 1fr, 1fr),
    tf[track],
    tf[cd_id],
    [titel],
    tf[1],
    tf[1],
    [Turnover],
    tf[2],
    tf[1],
    [Song \#1],
  ),
  sqltbl(
    columns: (1fr, 2fr),
    tf[id],
    [album],
    tf[1],
    [Repeater],
  ),
)
/ 3NF: No transitive dependencies: _land_ depends on _interpret_ \
#sqltbl(
  columns: (1fr, 2fr, 2fr, 1fr),
  tf[id],
  [album],
  [interpret],
  [land],
  tf[1],
  [Repeater],
  tc[Fugazi],
  tc[USA],
  tf[2],
  [Red Medicine],
  tc[Fugazi],
  tc[USA],
)
#grid(
  columns: (3fr, 2fr),
  [$=>$ cd], [interpret],
  sqltbl(
    columns: (1fr, 2fr, 2fr),
    tf[id],
    [album],
    [interpret],
    tf[1],
    [Repeater],
    [1],
  ),
  sqltbl(
    columns: (1fr, 2fr, 1fr),
    tf[id],
    [name],
    [land],
    tf[1],
    [Fugazi],
    [USA],
  ),
)
/ BCNF: Only dependencies on the key \
/ (Full) functional dependency: B depends on A; for each value of A there is exactly one value of B ($A -> B$) \
/ Partial functional dependency: B depends on A, but also on part of a composite key. \
/ Transitive dependency: B depends on attribute A, C depends on B ($A -> B and B -> C => A -> C$) \
/ Denormalization: Reverting to a lower NF (improves performance and reduces join complexity) \
== Anomalies \
Insertion anomaly, deletion anomaly, update anomaly \
// #colbreak()
= Data Control Language (DCL) \
#{
  show raw: set text(size: 4pt)
  ```bnf
  <role> ::= 'ALTER ROLE' <rname> <priv> { ',' <priv> }
  <grant> ::= 'GRANT' <actions>  'ON' <object> 'TO' <grantees> [ 'WITH GRANT OPTION' ]
  <revoke> ::= 'REVOKE' [ 'GRANT OPTION FOR' ] <actions>  'ON' <object> 'FROM' <grantees> ( 'CASCADE' | 'RESTRICT' )
  <priv> ::= [ 'NO' ] ( 'CREATEDB' | 'CREATEROLE' | 'INHERIT' )
  <action> ::=  'ALL' | 'SELECT' | 'DELETE' | 'TRIGGER' | (( 'INSERT' | 'UPDATE' | 'REFERENCES' ) '(' <columns> ')' )
  <actions> ::= <action> { ',' <action> }
  <grantees> ::= <role_name> { ',' <role_name> }
  <object> ::= 'TABLE' | 'COLUMN' | 'VIEW' | 'SEQUENCE' | 'DATABASE' | 'FUNCTION' | 'SCHEMA'
  ```
}
With `WITH GRANT OPTION`: The grantee can grant access to other users. $->$ `REVOKE ... CASCADE;`
```sql
CREATE ROLE u WITH LOGIN PASSWORD ''; -- user
GRANT INSERT ON TABLE t TO u WITH GRANT OPTION;
ALTER ROLE u CREATEROLE, CREATEDB, INHERIT;
CREATE ROLE r; -- group
GRANT r TO u; -- put user u in group r
REVOKE CREATE ON SCHEMA s FROM r;
CREATE ROLE u PASSWORD '' IN ROLE r; -- equivalent
```
== Read-only user
```sql
-- creating
REVOKE CREATE ON SCHEMA public FROM PUBLIC;
CREATE ROLE u WITH LOGIN ENCRYPTED PASSWORD ''
  NOINHERIT; -- don't inherit privileges
GRANT SELECT ON ALL TABLES IN SCHEMA public TO u;
-- read all new tables (also created by others):
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT
  SELECT ON TABLES TO u;
-- deleting
REVOKE SELECT ON ALL TABLES IN SCHEMA public FROM u;
ALTER DEFAULT PRIVILEGES IN SCHEMA public
  REVOKE SELECT ON TABLES FROM u;
DROP USER u;
```
== Row-Level Security (RLS) \
```sql
CREATE TABLE exams (
  id SERIAL, -- other fields...
  teacher VARCHAR(60) DEFAULT current_user
);
CREATE POLICY teachers_see_own_exams ON exams
  FOR ALL TO PUBLIC USING (teacher = current_user);
ALTER TABLE exams ENABLE ROW LEVEL SECURITY;
```
= Data Definition Language (DDL) \
#corr("Important: Do not forget NOT NULL where required") \
```sql
CREATE SCHEMA s;
CREATE TABLE t (
  id SERIAL PRIMARY KEY,
  name TEXT UNIQUE,
  grade DECIMAL(2,1) NOT NULL,
  fk INT FOREIGN KEY REFERENCES t2.id
    ON DELETE CASCADE,
  added TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  u VARCHAR(9) DEFAULT CURRENT_USER,
  CHECK (grade between 1 and 6)
);
ALTER TABLE t2 ADD CONSTRAINT c PRIMARY KEY (a, b);
TRUNCATE/DROP TABLE t;
```
== Inheritance \
/ One table per subclass and superclass: \
```sql
CREATE TABLE sup ( -- 3.a
  id SERIAL PRIMARY KEY,
  name TEXT UNIQUE
);
CREATE TABLE sub1 (
  id SERIAL PRIMARY KEY,
  age INT
);
CREATE TABLE sub2 (
  id SERIAL PRIMARY KEY
);
ALTER TABLE sub1 ADD CONSTRAINT id FOREIGN KEY
  REFERENCES sup (id);
ALTER TABLE sub2 ADD CONSTRAINT id FOREIGN KEY
  REFERENCES sup (id);
```
// #colbreak()
/ One table per subclass: Contains the respective subclass attributes \
```sql
CREATE TABLE sub1 ( -- 3.b
  id SERIAL PRIMARY KEY,
  name TEXT UNIQUE,
  age INT
);
CREATE TABLE sub2 (
  id SERIAL PRIMARY KEY,
  name TEXT UNIQUE
);
```
/ Single table for the superclass: Contains all attributes \
```sql
CREATE TABLE sup ( -- 3.c
  id SERIAL PRIMARY KEY,
  name TEXT UNIQUE,
  age INT
);
```
== Junction tables \
```sql
CREATE TABLE a_b(
  a INTEGER REFERENCES a(id),
  b INTEGER REFERENCES b(id),
  PRIMARY KEY(a, b)
);
```
== Views \
Results are queried dynamically each time \
```sql
CREATE VIEW v (id, u) AS SELECT id, u FROM t;
-- complex query
CREATE VIEW cheap_restaurant_view AS
WITH big_restaurant AS (
  SELECT * FROM restaurant
  WHERE anzahl_plaetze >= 20
)
SELECT r.name AS restaurant_name, s.name,
  MIN(g.preis) AS cheap_gericht
FROM big_restaurant r
LEFT JOIN skigebiet s ON (s.id = r.skigebiet_id)
LEFT JOIN menukarte m ON (r.id = m.restaurant_id)
LEFT JOIN menu_gericht mg ON (m.id = mg.menu_id)
LEFT JOIN gericht g ON (g.id = mg.gericht_id)
WHERE ist_tagesmenu = true
GROUP BY r.id, s.id, restaurant_name
HAVING MIN(g.preis) >= 3
ORDER BY cheap_gericht;
```
=== Updatable View \
Views are updatable when these criteria are met: \
- A single "base table"
- No aggregates, DISTINCT, GROUP BY, or HAVING
- All columns must map directly to the original table
=== Materialized View \
Stores the result on disk \
```sql
CREATE MATERIALIZED VIEW mv AS SELECT * FROM t;
REFRESH MATERIALIZED VIEW mv; -- refresh results
```
== Temporary tables \
```sql
CREATE TEMPORARY TABLE temp_products (
  id SERIAL PRIMARY KEY,
  product_name TEXT
);

INSERT INTO temp_products (product_name) VALUES
  ('Product A'), ('Product B'), ('Product C');

SELECT ts.product_name, ts.quantity FROM
  temp_sales ts JOIN temp_products tp ON
  ts.product_name = tp.product_name;
```
== Data types \
```sql
CREATE TYPE grade AS ENUM('A','B','C','D','E','F');
NUMERIC(4, 2) /* 99.99 */ NUMERIC(2, 1) /* 9.9 */
VARCHAR(5) /* 'abcde' */  CHAR(5) /* 'abcde' */
```
== Three-valued logic (cursed)\
```sql
SELECT NULL IS NULL; -- true
SELECT NULL = NULL;  -- [unknown]
```
// #colbreak()
#deftblge(
  [INTEGER/INT],
  [INTEGER/INT],
  [Integer (4 bytes)],
  [BIGINT],
  [BIGINT],
  [Large integer (8 bytes)],
  [SMALLINT],
  [SMALLINT],
  [Small integer (2 bytes)],
  [REAL],
  [REAL],
  [Single precision float (4 bytes)],
  [NUMERIC(precision,\ scale)],
  [NUMERIC(precision,\ scale)],
  [Exact numeric of selectable precision\ Alias for ```sql DECIMAL(precision, scale)```],
  [DOUBLE PRECISION],
  [DOUBLE PRECISION],
  [Double precision float (8 bytes)],
  [SERIAL],
  [SERIAL],
  [Auto-incrementing integer (4 bytes)],
  [BIGSERIAL],
  [BIGSERIAL],
  [Auto-incrementing large integer (8 bytes)],
  [SMALLSERIAL],
  [SMALLSERIAL],
  [Auto-incrementing small integer (2 bytes)],
  [CHARACTER/\ CHAR(size)],
  [CHARACTER/\ CHAR(size)],
  [Fixed-length, blank-padded string],
  [VARCHAR(size)],
  [VARCHAR(size)],
  [Variable-length, non-blank-padded string],
  [TEXT],
  [TEXT],
  [Variable-length character string],
  [BOOLEAN],
  [BOOLEAN],
  [Logical Boolean (true/false)],
  [DATE],
  [DATE],
  [Calendar date (year, month, day)],
  [TIME],
  [TIME],
  [Time of day (no time zone)],
  [TIMESTAMP],
  [TIMESTAMP],
  [Date and time (no time zone)],
  [TIMESTAMP WITH\ TIME ZONE],
  [TIMESTAMP WITH\ TIME ZONE],
  [Date and time with time zone],
  [INTERVAL],
  [INTERVAL],
  [Time interval],
  [JSON],
  [JSON],
  [JSON data],
  [UUID],
  [UUID],
  [Universally unique identifier],
  [ARRAY OF base_type],
  [ARRAY OF base_type],
  [Array of values],
)
=== Casting \
*Explicit*
```sql
CAST(5 AS float8) = 5::float8
SELECT 'ABCDEFG'::NUMERIC; -- error
SELECT SAFE_CAST('ABCDEFG' AS NUMERIC); -- NULL
```
*Implicit*
```sql
SELECT 5 + 3.2; -- 5 is cast to 5.0 (numeric)
SELECT 'Number ' || 42; -- 42 is cast to '42'
SELECT true AND 1; -- 1 is treated as true
SELECT CURRENT_TIMESTAMP + INTERVAL '1 day';
-- CURRENT_TIMESTAMP to date ^
SELECT '100'::text + 1; -- '100' is cast to 100
```
= Data Manipulation Language (DML)
#{
  show raw: set text(size: 4pt)
  ```bnf
  <select> ::= [ 'WITH' [ 'RECURSIVE' ] <with_query> [',' ...] ]
  'SELECT' [ 'ALL' | 'DISTINCT' [ 'ON' ( <expression> [',' ...] ) ] ]
      [ { '*' | <expression> [ [ 'AS' ] <output_name> ] } [',' ...] ]
      [ 'FROM' <from_item> [',' ...] ]
      [ 'WHERE' <condition> ]
      [ 'GROUP BY' [ 'ALL' | 'DISTINCT' ] <grouping_elem> [',' ...] ]
      [ 'HAVING' <condition> ]
      [ 'WINDOW' <window_name> 'AS' ( <window_def> ) [',' ...] ]
      [ { 'UNION' | 'INTERSECT' | 'EXCEPT' } [ 'ALL' | 'DISTINCT' ] <select> ]
      [ 'ORDER BY' <expression> [ 'ASC' | 'DESC' | 'USING' <op> ] [ 'NULLS' { 'FIRST' | 'LAST' } ] [',' ...] ]
      [ 'LIMIT' { <count> | 'ALL' } ]
      [ 'OFFSET' <start> [ 'ROW' | 'ROWS' ] ]

  <from_item> ::= <table> [ '*' ] [ [ 'AS' ] <alias> [ ( <col_alias> [',' ...] ) ] ]
      [ 'LATERAL' ] ( <select> ) [ [ 'AS' ] <alias> [ ( <col_alias> [',' ...] ) ] ]
      <with_query_name> [ [ 'AS' ] <alias> [ ( <col_alias> [',' ...] ) ] ]
      <from_item> <join_type> <from_item> { 'ON' <join_condition> | 'USING' ( <join_column> [',' ...] ) [ 'AS' <join_using_alias> ] }
      <from_item> 'NATURAL' <join_type> <from_item>
      <from_item> 'CROSS JOIN' <from_item>

  <with_query> ::= <name> [ ( <col_name> [',' ...] ) ] 'AS' ( <select> | <values> | <insert> | <update> | <delete> | <merge> )
          [ 'USING' <cycle_path_col_name> ]
  ```
}
== Joins
#grid(
  columns: (auto, auto, auto),
  [
    users (_u_)
    #sqltbl(
      columns: (auto, auto),
      [id],
      [name],
      tf[1],
      tf[Alice],
      tf[2],
      tf[Bob],
    )],
  [
    actions (_a_)
    #sqltbl(
      columns: (auto, auto, auto),
      [id],
      [uid],
      [action],
      ts[7],
      ts[1],
      ts[LOGIN],
      ts[8],
      ts[2],
      ts[VIEW],
      ts[9],
      ts[4],
      ts[LOGIN],
    )],
  [*INFO:* FK _uid_ omitted from the query results below to save space],
)
// #colbreak()
#grid(
  columns: (auto, auto),
  [=== Inner Join \
    Rows that match in both tables
    ```sql
    SELECT u.*, a.* FROM u INNER JOIN a ON u.id = a.uid;
    ```
  ],
  sqltbl(
    columns: (auto, auto, auto, auto, auto),
    [],
    tf[],
    tf[],
    ts[],
    ts[],
    [1],
    tf[1],
    tf[Alice],
    ts[7],
    ts[LOGIN],
  ),
)
#grid(
  columns: (auto, auto),
  [=== Equi Join \
    Like Inner Join
    ```sql
    SELECT u.*, a.* FROM u JOIN a ON u.id = a.uid;
    ```
  ],
  sqltbl(
    columns: (auto, auto, auto, auto, auto),
    [],
    tf[],
    tf[],
    ts[],
    ts[],
    [1],
    tf[1],
    tf[Alice],
    ts[7],
    ts[LOGIN],
  ),
)
#grid(
  columns: (auto, auto),
  [=== Natural Join \
    Like Inner Join, but without duplicates
    ```sql
    SELECT u.*, a.* FROM u NATURAL JOIN a ON u.id=a.uid;
    ```
  ],
  sqltbl(
    columns: (auto, auto, auto, auto, auto),
    [],
    tf[],
    tf[],
    ts[],
    ts[],
    [1],
    tf[1],
    tf[Alice],
    ts[7],
    ts[LOGIN],
  ),
)
#grid(
  columns: (auto, auto),
  [=== Semi Join \
    Only rows from a for which b must match
    ```sql
    SELECT * FROM u WHERE EXISTS
    (SELECT 1 FROM a WHERE u.id = a.uid);
    ```
  ],
  sqltbl(
    columns: (auto, auto, auto),
    [],
    tf[],
    tf[],
    [1],
    tf[1],
    tf[Alice],
  ),
)
#grid(
  columns: (auto, auto),
  [=== Anti Join \
    Only rows from a for which b must not match
    ```sql
    SELECT * FROM u WHERE NOT EXISTS
      (SELECT 1 FROM a WHERE u.id = a.uid);
    ```
  ],
  sqltbl(
    columns: (auto, auto, auto),
    [],
    tf[],
    tf[],
    [1],
    tf[2],
    tf[Bob],
  ),
)
#grid(
  columns: (auto, auto),
  [=== Left outer Join \
    All rows from both tables; NULL for b if there is no match
    ```sql
    SELECT u.*, a.* FROM u LEFT JOIN a ON u.id = a.uid;
    ```
  ],
  sqltbl(
    columns: (auto, auto, auto, auto, auto),
    [],
    tf[],
    tf[],
    ts[],
    ts[],
    [1],
    tf[1],
    tf[Alice],
    ts[7],
    ts[LOGIN],
    [2],
    tf[2],
    tf[Bob],
    [],
    [],
  ),
)
#grid(
  columns: (auto, auto),
  [=== Right outer Join \
    All rows from both tables; NULL for a if there is no match
    ```sql
    SELECT u.*, a.* FROM u RIGHT JOIN a ON u.id = a.uid;
    ```
  ],
  sqltbl(
    columns: (auto, auto, auto, auto, auto),
    [],
    tf[],
    tf[],
    ts[],
    ts[],
    [1],
    tf[1],
    tf[Alice],
    ts[7],
    ts[LOGIN],
    [3],
    [],
    [],
    ts[8],
    ts[VIEW],
    [4],
    [],
    [],
    ts[9],
    ts[LOGIN],
  ),
)
#grid(
  columns: (auto, auto),
  [=== Full outer Join \
    All rows from both tables; NULL if there is no match
    ```sql
    SELECT u.*, a.* FROM u FULL OUTER JOIN a ON u.id = a.uid;
    ```
  ],
  sqltbl(
    columns: (auto, auto, auto, auto, auto),
    [],
    tf[],
    tf[],
    ts[],
    ts[],
    [1],
    tf[1],
    tf[Alice],
    ts[7],
    ts[LOGIN],
    [2],
    tf[2],
    tf[Bob],
    [],
    [],
    [3],
    [],
    [],
    ts[8],
    ts[VIEW],
    [4],
    [],
    [],
    ts[9],
    ts[LOGIN],
  ),
)
#grid(
  columns: (auto, auto),
  [=== Cross Join \
    Returns all possible combinations of two tables.
    ```sql
    SELECT * FROM u CROSS JOIN a;
    ```
  ],
  sqltbl(
    columns: (auto, auto, auto, auto, auto),
    [],
    tf[],
    tf[],
    ts[],
    ts[],
    [1],
    tf[1],
    tf[Alice],
    ts[7],
    ts[LOGIN],
    [2],
    tf[1],
    tf[Alice],
    ts[8],
    ts[VIEW],
    [3],
    tf[1],
    tf[Alice],
    ts[9],
    ts[LOGIN],
    [4],
    tf[2],
    tf[Bob],
    ts[7],
    ts[LOGIN],
    [5],
    tf[2],
    tf[Bob],
    ts[8],
    ts[VIEW],
    [6],
    tf[2],
    tf[Bob],
    ts[9],
    ts[LOGIN],
  ),
)
#grid(
  columns: (auto, auto),
  [=== Union \
    "Combines" two SELECTs without duplicates. \
    Prerequisite: Columns must contain similar data types. *Union all* is like Union, but with duplicates $=>$ Recursive CTEs
  ],
  sqltbl(
    columns: (auto, auto),
    [],
    table.cell(inset: 0.5pt, [#box(
        fill: colors-l.green,
        width: 10pt,
        height: 4pt,
      )#box(fill: colors.comment, width: 10pt, height: 4pt)]),
    [1],
    tf[Alice],
    [2],
    tf[Bob],
    [3],
    ts[LOGIN],
    [4],
    ts[VIEW],
  ),
)
```sql
SELECT name FROM u UNION SELECT action FROM a;
```
#grid(
  columns: (auto, auto),
  [
    === Lateral Join \
    Allows subqueries referencing the other tables
  ],
  sqltbl(
    columns: (auto, auto, auto),
    [],
    tf[],
    ts[],
    [1],
    [],
    ts[LOGIN],
  ),
)
```sql
SELECT u.*, x.action FROM u JOIN LATERAL
  (SELECT * FROM a WHERE a.uid != u.id)
  AS x ON TRUE;
```
== INSERT \
```sql
INSERT INTO t (added, grade)
  VALUES ('2002-10-10', 1) RETURNING id;
```
== UPDATE \
```sql
UPDATE t SET grade = grade+1, name='' WHERE id = 1;
```
// #colbreak()
== Subqueries
```sql
SELECT * FROM t WHERE grade > ANY
  (SELECT g FROM t2);
SELECT * FROM t WHERE EXISTS (SELECT g FROM t2);
-- ALL, ANY, IN, EXISTS, =
```

== GROUP BY
```sql
SELECT id, COUNT(*) FROM t
  GROUP BY grade, id HAVING COUNT(*) > 2;
```
== WHERE
```sql
BETWEEN 1 AND 5; LIKE '___%'; AND; IS (NOT) NULL
IN (1, 5)      ; LIKE '%asd'; OR ;
```
== Aggregate functions
```sql
COUNT   ; SUM   ; MIN   ; MAX   ; AVG
```
== Other functions
```sql
COALESCE(a1, a2, ...); -- returns first non-null arg
```
== Common Table Expressions (CTE) \
- Allow row-by-row output
- Allow queries to act as parameters
- Can be recursive
```sql
-- normal
WITH cte AS (SELECT * FROM t) SELECT * FROM cte;
WITH tmp(id, name) AS (SELECT id, name FROM t)
  SELECT id, name FROM tmptable;
-- rekursiv
WITH RECURSIVE q AS (
    SELECT * FROM t WHERE grade > 1
  UNION ALL SELECT * FROM t INNER JOIN q ON
    q.u = t.name
) SELECT id as 'ID' FROM q;
```
== Window Functions
```sql
SELECT id, RANK() OVER
  (ORDER BY grade DESC) as r FROM t;
SELECT id, u, LAG(name, 1) OVER
  (PARTITION BY fk ORDER BY id DESC) FROM t;
-- PERCENT/DENSE_RANK(), FIRST_VALUE(v), LAST_VALUE(n)
-- NTH_VALUE(v,n), NTILE(n), LEAD(v,o), ROW_NUMBER()
```
= Relational algebra \
$pi_(R 1,R 4) (R)$ ```sql SELECT R1,R4 FROM R;``` #h(1fr) (Projection)\
$sigma_(R 1 > 30) (R)$ ```sql SELECT * FROM R WHERE R1 > 30;``` #h(1fr) (Selection)\
$rho_("a" <- "R")$ ```sql SELECT * FROM R AS a;``` #h(1fr) (Renaming/Alias)\
$R times S$ ```sql SELECT * FROM R,S;``` #h(1fr) (Cartesian product)\
$R attach(limits(join), b: A=B) S$ ```sql SELECT * FROM R JOIN S ON R.A=S.B;``` #h(1fr) (Join)\
= INDEX
#table(
  columns: (auto, 1fr, 1fr, 1fr, 1fr),
  [], [B-Tree], [Hash], [BRIN], [ISAM],
  [Equality queries], cg, cg, cr, cg,
  [Range Queries], cg, cr, cg, cr,
  [Sorted data], cg, cr, cg, cg,
  [Large tables], cb, table.cell(fill: colors-l.blue, [for =]), cg, cg,
  [Frequent queries], cg, cb, cg, cr,
  [Direct access via PK], cg, cg, cr, cb,
  [Overflow pages], cg, cg, cr, cg,
)
```sql
CREATE INDEX i ON t/*USING BTREE*/ (grade,UPPER(u));
CREATE INDEX j ON t (fk) INCLUDE (added) WHERE fk>4;
DROP INDEX i;
```
= Transactions \
Note: PostgreSQL has no nested transactions. \
/ Atomicity: All or nothing \
/ Consistency: A consistent state is preserved \
/ Isolation: A transaction is isolated from other transactions \
/ Durability: Changes are persistent \
```sql
BEGIN;  SAVEPOINT s;
COMMIT; ROLLBACK /*TO SAVEPOINT s*/;
```
// #colbreak()
= Isolation
```sql
SET TRANSACTION ISOLATION LEVEL ...; -- transaction
SET SESSION CHARACTERISTICS AS TRANSACTION
  ISOLATION LEVEL ...; --  session
```
/ READ UNCOMMITTED: Reads are not synchronized (no read lock); reads ignore all locks \
/ READ COMMITTED: Reads are synchronized briefly/temporarily (default); write locks last for the whole transaction, read locks only briefly \
/ REPEATABLE READ: Individual row accesses are synchronized; read and write locks last for the whole transaction \
/ SERIALIZABLE: Full isolation according to ACID \
#table(
  columns: (1fr, 1fr, 1fr, 1fr, 1fr),
  [], [Read Uncommitted], [Read Committed], [Repeatable Read], [Serializable],
  [Dirty Write], cb, cb, cb, cr,
  [Dirty Read], cg, cr, cr, cr,
  [Lost Update], cg, cg, cr, cr,
  [Fuzzy Read], cg, cg, cr, cr,
  [Phantom Read], cg, cg, cg, cr,
  [Read Skew], cg, cg, cr, cr,
  [Write Skew], cg, cg, cg, cb,
  [Durability], cg, cg, cr, cr,
  [Atomicity], cr, cr, cg, cg,
)
\* Only possible in SQL92; PSQL >= 9.1 prevents this \
/ Dirty Read: Reading data from uncommitted transactions \
/ Fuzzy Read: Different values when reading the same data repeatedly (modified by another transaction) \
/ Phantom Read: Rows inserted/deleted by another transaction \
/ Read Skew: Reading data that changes during the transaction \
/ Write Skew: Multiple transactions read data and modify it \
/ Deadlock: Multiple transactions block each other while waiting for the same resource \
/ Cascading Rollback: A transaction fails and all dependent transactions must also be rolled back \
#table(
  columns: (1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
  [],
  [Serializable],
  [Deadlocks],
  [Cascading RollB.],
  [Conflict rollback],
  [High concurrency],
  [Realistic],

  [Two-Phase Locking], cg, cg, cg, cr, cr, cr,
  [Strict 2PL], cg, cg, cr, cr, cr, cg,
  [Preclaiming 2PL], cg, cr, cr, cr, cr, cr,
  [Validation-based], cg, cr, cg, cg, cg, cg,
  [Time-stamp-based], cg, cr, cg, cg, cg, cg,
  [Snapshot Isolation], cr, cb, cr, cg, cg, cg,
  [SSI], cg, cb, cr, cg, cg, cg,
)
\* Deadlock in PSQL with Snapshot Isolation \
*SQL example* \
```sql
BEGIN;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
UPDATE accounts SET balance = balance - 100.00
    WHERE name = 'Alice';
SAVEPOINT my_savepoint;
UPDATE accounts SET balance = balance + 100.00
    WHERE name = 'Bob';
ROLLBACK TO my_savepoint;
UPDATE accounts SET balance = balance + 100.00
    WHERE name = 'Wally';
COMMIT;
```
// #colbreak()
== Two-Phase Locking (2PL) \
Ensures transaction isolation \
+ Growing Phase: The transaction can acquire new locks but cannot release any
+ Shrinking Phase: Locks can be released, but no new locks can be acquired
/ Strict 2PL: Transactions release locks only after commit \
/ Preclaiming 2PL: All locks are acquired at the start of the transaction\
*#[_S_]hared* _Lock_: Read access (multiple transactions) \
*E#[_X_]clusive* _Lock_: Write & read access (one transaction) \
/ Starvation: A transaction never gets the chance to finish its work because locks keep blocking it \
=== Optimistic locking \
Transactions operate without initial locks. Check for conflicts at the end $->$ roll back changes. \
=== Pessimistic locking (Preclaiming 2PL)\
Transactions request locks immediately so that other transactions cannot access or modify the same data simultaneously. \
#box(fill: colors-l.green, inset: 2pt)[*Growing phase*] #h(1fr) #box(
  fill: colors-l.blue,
  inset: 2pt,
)[*Shrinking phase*] \
#[
  #let cell = (..b) => node(width: 37pt, ..b)
  #let cell2 = (..b) => node(width: 25pt, ..b)
  #set text(size: 5pt)
  #diagram(
    spacing: (6pt, 0pt),
    node(enclose: ((0, -1), (1, -1)), [*T1*], stroke: none),
    node(enclose: ((3, -1), (4, -1)), [*T2*], stroke: none),
    cell((0, 0), [XLOCK(A)], name: <T1G1>),
    cell2((1, 0), [W(A)], name: <T1G2>),
    cell((3, 0), " "),
    cell2((4, 0), " "),
    cell((0, 1), " "),
    cell2((1, 1), " "),
    cell((3, 1), [SLOCK(A)], name: <T2G1>),
    cell2((4, 1), [R(A)], name: <T2G2>),
    cell((0, 3), " "),
    cell2((1, 3), " "),
    cell((3, 3), [UNLOCK(A)], name: <T2S1>),
    cell2((4, 3), [COMMIT], name: <T2S2>),
    cell((0, 5), " ", name: <T1G3>),
    cell2((1, 5), [R(A)], name: <T1G4>),
    cell((3, 5), " "),
    cell2((4, 5), " "),
    cell((0, 6), [UNLOCK(A)], name: <T1S1>),
    cell2((1, 6), [COMMIT], name: <T1S2>),
    cell((3, 6), " "),
    cell2((4, 6), " "),
    node(enclose: ((0, 7), (1, 7)), [$=>$ *OK*], stroke: none),
    node(
      enclose: (<T1G1>, <T1G2>, <T1G3>, <T1G4>),
      fill: colors-l.green,
      stroke: none,
      inset: 0pt,
    ),
    node(
      enclose: (<T1S1>, <T1S2>),
      fill: colors-l.blue,
      stroke: none,
      inset: 0pt,
    ),
    node(
      enclose: (<T2G1>, <T2G2>),
      fill: colors-l.green,
      stroke: none,
      inset: 0pt,
    ),
    node(
      enclose: (<T2S1>, <T2S2>),
      fill: colors-l.blue,
      stroke: none,
      inset: 0pt,
    ),
    edge(
      <T2G1>,
      (2, 2),
      (2, 6),
      <T1S2>,
      "->",
      [Waits for],
      label-angle: left,
      shift: (2pt, 0pt),
    ),
  )
  #diagram(
    spacing: (6pt, 0pt),
    node(enclose: ((0, -1), (1, -1)), [*T1*], stroke: none),
    node(enclose: ((3, -1), (4, -1)), [*T2*], stroke: none),
    cell((0, 0), [SLOCK(A)], name: <T1G1>),
    cell2((1, 0), [R(A)], name: <T1G2>),
    cell((3, 0), " "),
    cell2((4, 0), " "),
    cell((0, 1), " "),
    cell2((1, 1), " "),
    cell((3, 1), [SLOCK(B)], name: <T2G1>),
    cell2((4, 1), [R(B)], name: <T2G2>),
    cell((0, 3), [XLOCK(B)]),
    cell2((1, 3), [W(B)]),
    cell((3, 3), " "),
    cell2((4, 3), " "),
    cell((0, 5), " ", name: <T1G3>),
    cell2((1, 5), " ", name: <T1G4>),
    cell((3, 5), [XLOCK(A)]),
    cell2((4, 5), [W(A)]),
    cell((0, 6), [UNLOCK(A,B)], name: <T1S1>),
    cell2((1, 6), [COMMIT], name: <T1S2>),
    cell((3, 6), " ", name: <T2G4>),
    cell2((4, 6), " ", name: <T2G3>),
    cell((0, 7), " "),
    cell2((1, 7), " "),
    cell((3, 7), [UNLOCK(A)], name: <T2S1>),
    cell2((4, 7), [R(B)], name: <T2S2>),
    cell((0, 8), " "),
    cell2((1, 8), " "),
    cell((3, 8), [UNLOCK(B)], name: <T2S3>),
    cell2((4, 8), [COMMIT], name: <T2S4>),
    node(
      enclose: ((0, 9), (1, 9)),
      tr([$=>$ *Deadlock*]),
      stroke: none,
      name: <dl>,
    ),
    node(
      enclose: (<T1G1>, <T1G2>, <T1G3>, <T1G4>),
      fill: colors-l.green,
      stroke: none,
      inset: 0pt,
    ),
    node(
      enclose: (<T1S1>, <T1S2>),
      fill: colors-l.blue,
      stroke: none,
      inset: 0pt,
    ),
    node(
      enclose: (<T2G1>, <T2G2>, <T2G3>, <T2G4>),
      fill: colors-l.green,
      stroke: none,
      inset: 0pt,
    ),
    node(
      enclose: (<T2S1>, <T2S2>, <T2S3>, <T2S4>),
      fill: colors-l.blue,
      stroke: none,
      inset: 0pt,
    ),
    edge(
      (1, 2),
      (2, 2),
      (2, 7),
      <T2S1>,
      "->",
      tr[Waits for],
      label-angle: right,
      shift: (4pt, 0pt),
      stroke: colors.red,
    ),
    edge(
      (4, 4),
      (5, 4),
      (5, 9),
      (1, 9),
      <T1S2>,
      "->",
      tr[Waits for],
      label-pos: 65%,
      shift: (4pt, 0pt),
      stroke: colors.red,
    ),
  )
]
== Serializability \
/ Serial schedule: Executes transactions without interleaving
/ Not serializable: #let node = node.with(
    width: 8pt,
    height: 8pt,
    inset: 3pt,
  ); #grid(
    columns: (3fr, 1fr),
    [
      #set text(weight: "bold")
      S1=#td([R1])#math.underbracket([(x)#tr([R2])#math.underbracket([(x)#td([W1])])\(x)#td([R1])\(y)#tr([W2])])\(x)#td([W1])\(y)
    ],
    diagram(
      spacing: (2em, 2em),
      node-shape: circle,
      node((1, 1), "T1", name: <t1>, fill: colors-l.blue),
      node((2, 1), "T2", name: <t2>, fill: colors-l.red),
      edge(<t1>, <t2>, shift: (5pt, 5pt), "-|>"),
      edge(<t2>, <t1>, shift: (5pt, 5pt), "-|>"),
    ),
  )
/ Conflicting pairs: #grid(
    columns: (1fr, 1fr),
    [#td([R1])\(x) < #tr([W2])\(x)], [#tr([R2])\(x) < #td([W1])\(x)],
  )
*Conflict-serializable:* \
#td([r1(b)])#tr([r2(b)w2(b)r2(c)r2(d)])#tg([w3(a)])#tp([r4(d)])#tg([r3(b)])#tp(
  [w4(d)],
)#tb([r5(c)r5(a)])#tp([w4(c)]) \
*Conflict-equivalent serial schedule:* \
#td([r1(b)])#tr([r2(b)w2(b)r2(c)r2(d)])#tg([w3(a)r3(b)])#tb([r5(c)r5(a)])#tp(
  [r4(d)w4(d)w4(c)],
) \
#align(center, diagram(
  spacing: (2em, 2em),
  node-shape: circle,
  node((1, 1), "T1", name: <t1>, fill: colors-l.darkblue),
  node((2, 1), "T2", name: <t2>, fill: colors-l.red),
  node((3, 1), "T3", name: <t3>, fill: colors-l.green),
  node((5, 1), "T4", name: <t4>, fill: colors-l.purple),
  node((4, 1), "T5", name: <t5>, fill: colors-l.blue),
  edge(<t1>, <t2>, "-|>"),
  edge(<t2>, <t3>, "-|>"),
  edge(<t2>, <t4>, "-|>", bend: 30deg),
  edge(<t3>, <t5>, "-|>"),
  edge(<t5>, <t4>, "-|>"),
))
#deftblge(
  [Seriell],
  [Serial],
  [All transactions in a schedule are ordered],
  [Konfliktäquivalent],
  [Conflict-equivalent],
  [The order of all pairs of conflicting actions is the same in both schedules],
  [Konfliktserialisierbar],
  [Conflict-serializable],
  [A schedule is conflict-equivalent to a serial schedule],
)
== Full backup \
Exact copy of the entire DB \
== Incremental backup \
Backs up only data changed since the last backup. \
== Logical backup (SQL Dump) \
Does not block transactions. For medium-sized datasets; compatible with new PG versions and other machines. \
== Physical backup (File System) \
The database must be stopped; faster than a logical backup; works only with the same PG "major version". \
// #colbreak()
== Multi-Version Concurrency Control (MVCC) \
Allows multiple transactions to run concurrently. Each change creates a new version of the data. Readers see older versions, while writers see the latest versions. \
== Write-Ahead Log (WAL) \
Writes transaction changes to the log, then logs the commit, then updates the DB. Can be replayed after a crash \
*LSN, TaID, PageID, Redo, Undo, PrevLSN* \
= SQL examples
```sql
CREATE TABLE pferd (
  pnr SERIAL PRIMARY KEY,
  name TEXT,
  alter INT,
  zuechternr INT REFERENCES stall.pk,
  vaternr INT REFERENCES pferd.pk
);
CREATE TABLE stall (
  zuechternr SERIAL PRIMARY KEY,
  name TEXT,
  plz INT,
  ort TEXT,
  strasse TEXT
);

-- Welche Züchter haben in ihren Ställen mindestens 1 Kind von dem Vater mit Namen "Hermes"

-- Eleganteste anfrage unkorreliert
SELECT s.name FROM staelle s
WHERE s.zuechternr IN (
  SELECT p.zuechternr
  FROM pferde p
  JOIN pferde p2 ON p2.pnr = p.vaternr
  WHERE p2.name = 'Hermes'
);
-- Kürzeste anfrage
SELECT DISTINCT s.name FROM staelle s
JOIN pferde p ON p.zuechternr = s.zuechternr
JOIN pferde p2 ON p2.pnr = p.vaternr
WHERE p2.name = 'Hermes';
--
SELECT DISTINCT s.name FROM staelle s
JOIN pferde p ON p.zuechternr = s.zuechternr
WHERE EXISTS (
  SELECT vaternr FROM pferde p2
  WHERE p2.pnr = p.vaternr AND p2.name = 'Hermes'
);

-- RECURSIVE CTE
WITH RECURSIVE tens AS (
   SELECT 1 as n
 UNION ALL
   SELECT n+1 FROM tens
) SELECT n FROM tens limit 10;
-- 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
```
= B-tree \
#grid(
  columns: (1fr, 1fr),
  [
    #text(fill: colors.darkblue)[+4]
    #diagram(
      spacing: (0em, 1em),
      node((3, 1), "10", name: <fst>),
      node((4, 1), " ", name: <fst2>),
      node((5, 1), " "),
      node((6, 1), " "),
      node((0, 2), "1"),
      node((1, 2), "2", name: <snd>),
      node((2, 2), "3", fill: colors-l.green),
      node((3, 2), "7", stroke: colors.green),
      node((5, 2), "13"),
      node((6, 2), "19", name: <trd>),
      node((7, 2), " "),
      node((8, 2), " "),
      edge(<fst>, <snd>, shift: (1pt, -1pt), "-|>"),
      edge(<fst2>, <trd>, shift: (-6pt, 6pt), "-|>"),
    )],
  [
    #text(fill: colors.darkblue)[+11,+21]
    #diagram(
      spacing: (0em, 1em),
      node((4, 1), "3", fill: colors-l.green, name: <n>),
      node((5, 1), "10", name: <fst>),
      node((6, 1), " ", name: <fst2>),
      node((7, 1), " "),
      node((0, 2), "1"),
      node((1, 2), "2", name: <snd>),
      node((2, 2), " "),
      node((3, 2), " "),
      node((2, 3), "4", fill: colors-l.blue),
      node((3, 3), "7", stroke: colors.green, name: <frt>),
      node((4, 3), " "),
      node((5, 3), " "),
      node((5, 2), "13"),
      node((6, 2), "19", name: <trd>),
      node((7, 2), " "),
      node((8, 2), " "),
      edge(<n>, <snd>, shift: (2pt, -2pt), "-|>"),
      edge(<fst2>, <trd>, shift: (-7pt, 7pt), "-|>"),
      edge(<fst>, <frt>, shift: (-2pt, 2pt), stroke: colors.darkblue, "-|>"),
    )],

  [
    #text(fill: colors.darkblue)[+12]
    #diagram(
      spacing: (0em, 1em),
      node((4, 1), "3", name: <n>),
      node((5, 1), "10", name: <fst>),
      node((6, 1), " ", name: <fst2>),
      node((7, 1), " "),
      node((0, 2), "1"),
      node((1, 2), "2", name: <snd>),
      node((2, 2), " "),
      node((3, 2), " "),
      node((2, 3), "4"),
      node((3, 3), "7", name: <frt>),
      node((4, 3), " "),
      node((5, 3), " "),
      node((5, 2), "11", fill: colors-l.blue, stroke: colors.green),
      node((6, 2), "13", fill: colors-l.green, name: <trd>),
      node((7, 2), "19"),
      node((8, 2), "21", fill: colors-l.blue),
      edge(<n>, <snd>, shift: (2pt, -2pt), "-|>"),
      edge(<fst2>, <trd>, shift: (-7pt, 7pt), stroke: colors.darkblue, "-|>"),
      edge(<fst>, <frt>, shift: (-2pt, 2pt), "-|>"),
    )],
  [#diagram(
    spacing: (0em, 1em),
    node((4, 1), "3", name: <n>),
    node((5, 1), "10", name: <fst>),
    node((6, 1), "13", fill: colors-l.green, name: <fst2>),
    node((7, 1), " ", name: <fst3>),
    node((0, 2), "1"),
    node((1, 2), "2", name: <snd>),
    node((2, 2), " "),
    node((3, 2), " "),
    node((2, 3), "4"),
    node((3, 3), "7", name: <frt>),
    node((4, 3), " "),
    node((5, 3), " "),
    node((8, 2), "19"),
    node((9, 2), "21", name: <trd>),
    node((10, 2), " "),
    node((11, 2), " "),
    node((6.5, 3), "11", stroke: colors.green),
    node((7.5, 3), "12", fill: colors-l.blue, name: <fth>),
    node((8.5, 3), " "),
    node((9.5, 3), " "),
    edge(<n>, <snd>, shift: (2pt, -2pt), "-|>"),
    edge(<fst3>, <trd>, shift: (-6pt, 6pt), "-|>"),
    edge(<fst2>, <fth>, shift: (-6pt, 6pt), stroke: colors.darkblue, "-|>"),
    edge(<fst>, <frt>, shift: (-2pt, 2pt), "-|>"),
  )],
) \

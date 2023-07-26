CREATE TABLE region (
  r_regionkey       INTEGER NOT NULL PRIMARY KEY,
  r_name            CHAR(25) NOT NULL,
  r_comment         VARCHAR(152)
);

IMPORT INTO region CSV DATA(
  'gs://sf-10/region.tbl'
) WITH delimiter='|';

CREATE TABLE nation (
      n_nationkey       INTEGER NOT NULL PRIMARY KEY,
      n_name            CHAR(25) NOT NULL,
      n_regionkey       INTEGER NOT NULL,
      n_comment         VARCHAR(152),
      INDEX n_rk        (n_regionkey ASC)
);

IMPORT INTO nation CSV DATA(
  'gs://sf-10/nation.tbl'
) WITH delimiter='|';

ALTER TABLE nation ADD CONSTRAINT nation_fkey_region FOREIGN KEY (n_regionkey) references region (r_regionkey);

CREATE TABLE part  (
  p_partkey         INTEGER NOT NULL PRIMARY KEY,
  p_name            VARCHAR(55) NOT NULL,
  p_mfgr            CHAR(25) NOT NULL,
  p_brand           CHAR(10) NOT NULL,
  p_type            VARCHAR(25) NOT NULL,
  p_size            INTEGER NOT NULL,
  p_container       CHAR(10) NOT NULL,
  p_retailprice     FLOAT NOT NULL,
  p_comment         VARCHAR(23) NOT NULL
);

IMPORT INTO part CSV DATA(
  'gs://sf-10/part.tbl.1',
  'gs://sf-10/part.tbl.2',
  'gs://sf-10/part.tbl.3',
  'gs://sf-10/part.tbl.4',
  'gs://sf-10/part.tbl.5',
  'gs://sf-10/part.tbl.6',
  'gs://sf-10/part.tbl.7',
  'gs://sf-10/part.tbl.8'
) WITH delimiter='|';

CREATE TABLE supplier (
  s_suppkey         INTEGER NOT NULL PRIMARY KEY,
  s_name            CHAR(25) NOT NULL,
  s_address         VARCHAR(40) NOT NULL,
  s_nationkey       INTEGER NOT NULL,
  s_phone           CHAR(15) NOT NULL,
  s_acctbal         FLOAT NOT NULL,
  s_comment         VARCHAR(101) NOT NULL,
  INDEX s_nk        (s_nationkey ASC)
);

IMPORT INTO supplier CSV DATA(
  'gs://sf-10/supplier.tbl.1',
  'gs://sf-10/supplier.tbl.2',
  'gs://sf-10/supplier.tbl.3',
  'gs://sf-10/supplier.tbl.4',
  'gs://sf-10/supplier.tbl.5',
  'gs://sf-10/supplier.tbl.6',
  'gs://sf-10/supplier.tbl.7',
  'gs://sf-10/supplier.tbl.8'
) WITH delimiter='|';

ALTER TABLE supplier ADD CONSTRAINT supplier_fkey_nation FOREIGN KEY (s_nationkey) references nation (n_nationkey);

CREATE TABLE partsupp (
  ps_partkey            INTEGER NOT NULL,
  ps_suppkey            INTEGER NOT NULL,
  ps_availqty           INTEGER NOT NULL,
  ps_supplycost         FLOAT NOT NULL,
  ps_comment            VARCHAR(199) NOT NULL,
  PRIMARY KEY           (ps_partkey, ps_suppkey),
  INDEX ps_sk           (ps_suppkey ASC)
);

IMPORT INTO partsupp CSV DATA(
  'gs://sf-10/partsupp.tbl.1',
  'gs://sf-10/partsupp.tbl.2',
  'gs://sf-10/partsupp.tbl.3',
  'gs://sf-10/partsupp.tbl.4',
  'gs://sf-10/partsupp.tbl.5',
  'gs://sf-10/partsupp.tbl.6',
  'gs://sf-10/partsupp.tbl.7',
  'gs://sf-10/partsupp.tbl.8'
) WITH delimiter='|';

ALTER TABLE partsupp ADD CONSTRAINT partsupp_fkey_part FOREIGN KEY (ps_partkey) references part (p_partkey);
ALTER TABLE partsupp ADD CONSTRAINT partsupp_fkey_supplier FOREIGN KEY (ps_suppkey) references supplier (s_suppkey);

CREATE TABLE customer (
  c_custkey         INTEGER NOT NULL PRIMARY KEY,
  c_name            VARCHAR(25) NOT NULL,
  c_address         VARCHAR(40) NOT NULL,
  c_nationkey       INTEGER NOT NULL,
  c_phone           CHAR(15) NOT NULL,
  c_acctbal         FLOAT NOT NULL,
  c_mktsegment      CHAR(10) NOT NULL,
  c_comment         VARCHAR(117) NOT NULL,
  INDEX c_nk        (c_nationkey ASC)
);

IMPORT INTO customer CSV DATA(
  'gs://sf-10/customer.tbl.1',
  'gs://sf-10/customer.tbl.2',
  'gs://sf-10/customer.tbl.3',
  'gs://sf-10/customer.tbl.4',
  'gs://sf-10/customer.tbl.5',
  'gs://sf-10/customer.tbl.6',
  'gs://sf-10/customer.tbl.7',
  'gs://sf-10/customer.tbl.8'
) WITH delimiter='|';

ALTER TABLE customer ADD CONSTRAINT customer_fkey_nation FOREIGN KEY (c_nationkey) references nation (n_nationkey);

CREATE TABLE orders (
  o_orderkey           INTEGER NOT NULL PRIMARY KEY,
  o_custkey            INTEGER NOT NULL,
  o_orderstatus        CHAR(1) NOT NULL,
  o_totalprice         FLOAT NOT NULL,
  o_orderdate          DATE NOT NULL,
  o_orderpriority      CHAR(15) NOT NULL,
  o_clerk              CHAR(15) NOT NULL,
  o_shippriority       INTEGER NOT NULL,
  o_comment            VARCHAR(79) NOT NULL,
  INDEX o_ck           (o_custkey ASC),
  INDEX o_od           (o_orderdate ASC)
);

IMPORT INTO orders CSV DATA(
  'gs://sf-10/orders.tbl.1',
  'gs://sf-10/orders.tbl.2',
  'gs://sf-10/orders.tbl.3',
  'gs://sf-10/orders.tbl.4',
  'gs://sf-10/orders.tbl.5',
  'gs://sf-10/orders.tbl.6',
  'gs://sf-10/orders.tbl.7',
  'gs://sf-10/orders.tbl.8'
) WITH delimiter='|';

ALTER TABLE orders ADD CONSTRAINT orders_fkey_customer FOREIGN KEY (o_custkey) references customer (c_custkey);

CREATE TABLE lineitem (
  l_orderkey      INTEGER NOT NULL,
  l_partkey       INTEGER NOT NULL,
  l_suppkey       INTEGER NOT NULL,
  l_linenumber    INTEGER NOT NULL,
  l_quantity      FLOAT NOT NULL,
  l_extendedprice FLOAT NOT NULL,
  l_discount      FLOAT NOT NULL,
  l_tax           FLOAT NOT NULL,
  l_returnflag    CHAR(1) NOT NULL,
  l_linestatus    CHAR(1) NOT NULL,
  l_shipdate      DATE NOT NULL,
  l_commitdate    DATE NOT NULL,
  l_receiptdate   DATE NOT NULL,
  l_shipinstruct  CHAR(25) NOT NULL,
  l_shipmode      CHAR(10) NOT NULL,
  l_comment       VARCHAR(44) NOT NULL,
  PRIMARY KEY     (l_orderkey, l_linenumber),
  INDEX l_ok      (l_orderkey ASC),
  INDEX l_pk      (l_partkey ASC),
  INDEX l_sk      (l_suppkey ASC),
  INDEX l_sd      (l_shipdate ASC),
  INDEX l_cd      (l_commitdate ASC),
  INDEX l_rd      (l_receiptdate ASC),
  INDEX l_pk_sk   (l_partkey ASC, l_suppkey ASC),
  INDEX l_sk_pk   (l_suppkey ASC, l_partkey ASC)
);

IMPORT INTO lineitem CSV DATA(
  'gs://sf-10/lineitem.tbl.1',
  'gs://sf-10/lineitem.tbl.2',
  'gs://sf-10/lineitem.tbl.3',
  'gs://sf-10/lineitem.tbl.4',
  'gs://sf-10/lineitem.tbl.5',
  'gs://sf-10/lineitem.tbl.6',
  'gs://sf-10/lineitem.tbl.7',
  'gs://sf-10/lineitem.tbl.8'
) WITH delimiter='|';

ALTER TABLE lineitem ADD CONSTRAINT lineitem_fkey_orders FOREIGN KEY (l_orderkey) references orders (o_orderkey);
ALTER TABLE lineitem ADD CONSTRAINT lineitem_fkey_part FOREIGN KEY (l_partkey) references part (p_partkey);
ALTER TABLE lineitem ADD CONSTRAINT lineitem_fkey_supplier FOREIGN KEY (l_suppkey) references supplier (s_suppkey);

<h1>retail-marketplace-rdbms</h1>
<p>Relational database architecture for smartphone retail, supply-chain tracking, and sales order processing</p>

<h2>Project description</h2>
<p>This project implements an enterprise relational database model designed during practical training at Win Interactive for a telecommunications retail network:</p>
<ol>
  <li>
    <dl>
      <dt><b>Inventory &amp; Supply-Chain Management:</b></dt>
      <dd>Maintains mobile device models with distinct color schemes, purchase costs, retail margins, and current stock balances.</dd>
      <dd>Links manufacturing brands (<code>firm</code>) with authorized distribution partners (<code>provider</code>) across multiple regions.</dd>
    </dl>
  </li>
  <li>
    <dl>
      <dt><b>Customer Order Pipeline:</b></dt>
      <dd>Processes customer orders linking selected hardware, optional extended warranty policies (<code>guarantee</code>), and loyalty discounts (<code>discount</code>).</dd>
      <dd>Enforces strict referential integrity via cascade delete and update triggers across all foreign keys.</dd>
    </dl>
  </li>
  <li>
    <dl>
      <dt><b>Sales Transaction Logging:</b></dt>
      <dd>Maps fulfilled customer orders to individual sales consultants (<code>employee</code>) and physical retail outlets (<code>market</code>).</dd>
      <dd>Enables margin analysis, commission tracking, and branch-level inventory distribution monitoring.</dd>
    </dl>
  </li>
</ol>

<h2>Project files</h2>
<table>
  <tr>
    <th colspan="2">retail-marketplace-rdbms</th>
  </tr>
  <tr>
    <td>main.py</td>
    <td>Automated Python orchestrator initializing the in-memory database and rendering analytical sales views</td>
  </tr>
  <tr>
    <td>sql/schema.sql</td>
    <td>Full DDL script containing 10 table definitions, constraints, and relational indices</td>
  </tr>
  <tr>
    <td>sql/queries.sql</td>
    <td>Analytical SQL statements for profit margin evaluation, inventory aging, and employee sales volume</td>
  </tr>
  <tr>
    <td>README.md</td>
    <td>Project documentation and structural architecture description</td>
  </tr>
  <tr>
    <td>.gitignore</td>
    <td>Exclusion rules for bytecode, local database files, and IDE environments</td>
  </tr>
</table>

<h2>Relational Entity-Relationship (ER) Overview</h2>
<pre>
 [firm] &lt;---+
            |
            +---(1:N)---&gt; [phone] &lt;---(1:N)---+
 [provider] +                                 |
                                              +---(1:N)---&gt; [order] &lt;---(1:N)--- [sales] &lt;---(N:1)--- [employee]
 [shopper] &lt;---(1:N)---&gt; [discount] &lt;---------+                |                     |
                                                               |                     +---(N:1)--- [market]
 [guarantee] &lt;-------------------------------------------------+
</pre>

<h2>Installation and launch</h2>
<ol>
  <b>
    <li>
      <dl>
        <dt>Clone repository</dt>
        <dd>
          <code>git clone https://github.com/Kyoryuu-lab/retail-marketplace-rdbms.git</code>
        </dd>
        <dd>
          <code>cd retail-marketplace-rdbms</code>
        </dd>
      </dl>
    </li>
  </b>
  <b>
    <li>
      <dl>
        <dt>Execute automated demonstration</dt>
        <dd>Runs directly via the Python standard library without external dependencies:</dd>
        <dd>
          <code>python main.py</code>
        </dd>
      </dl>
    </li>
  </b>
</ol>

<h2>Example of console output (python main.py)</h2>
<samp>
  <p>
    ================================================================================<br />
    &nbsp;&nbsp;RETAIL MARKETPLACE RDBMS - DATA INTEGRITY &amp; SALES ANALYTICS<br />
    ================================================================================<br />
    [+] Database schema successfully verified and initialized.<br />
    [+] Sample inventories, employees, and customer orders seeded.<br />
    <br />
    ================================================================================<br />
    &nbsp;&nbsp;EXECUTIVE SALES SUMMARY (JOIN ACROSS 7 TABLES)<br />
    ================================================================================<br />
    +---------+-----------------+-------+------------+--------------+-----------------+------------+---------------+-----------------------------+<br />
    | sale_id | device_model&nbsp;&nbsp;&nbsp;&nbsp;| brand | base_price | discount_pct | effective_price | net_profit | sales_agent&nbsp;&nbsp;&nbsp;| store_location&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|<br />
    +---------+-----------------+-------+------------+--------------+-----------------+------------+---------------+-----------------------------+<br />
    | 1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;| iPhone 15 Pro&nbsp;&nbsp;&nbsp;| Apple | 1199.0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;| 5&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;| 1139.05&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;| 189.05&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;| Tkachenko O.&nbsp;&nbsp;| 600-richchia St 17, Vinnytsia |<br />
    +---------+-----------------+-------+------------+--------------+-----------------+------------+---------------+-----------------------------+<br />
    <br />
    [+] Verification completed successfully.<br />
  </p>
</samp>

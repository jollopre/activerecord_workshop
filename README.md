# Active Record - Object Relational Mapping for Ruby

ActiveRecord is an Object Relational Mapper (ORM). It can represent *business data* and *logic*, however we are going to focus *only* in its ability to facilitate the creation and use of ruby objects that *map business data* that is persisted into a relational database.

Throughout this workshop, we are going to tackle 3 topics:

* Performing *database operations* in a object-oriented fashion
* Representing *data models* and their *associations*
* Explaining how to evolve a database schema over time using *migrations*

## Database operations - Query Methods

ActiveRecord offers a rich interface that permits chaining methods in order to build from simple to complex queries. For instance, methods such as `select, from, joins, where` always return [ActiveRecord::Relation](https://api.rubyonrails.org/classes/ActiveRecord/Relation.html) objects. These objects are only **lazy evaluated** when you try to access to one of the records returned by the SQL generated.

This library also has some query methods that are not chainable, i.e. they are evaluated immediately and return single values (e.g. an instance of a model, an Integer, an Array of values, etc). The most commond used methods are `find, find_by, pluck`, as well as aggregated methods such as `avg, count, min, max, etc`.

* [where](https://api.rubyonrails.org/classes/ActiveRecord/QueryMethods.html#method-i-where): permits building the WHERE clause according to the arguments passed. When multiple chained where are used these are concatenated using sql `AND`.
* [and](https://api.rubyonrails.org/classes/ActiveRecord/QueryMethods.html#method-i-and), [or](https://api.rubyonrails.org/classes/ActiveRecord/QueryMethods.html#method-i-or), [not](https://api.rubyonrails.org/classes/ActiveRecord/QueryMethods/WhereChain.html#method-i-not): permits adding logical operands to the where clause.
* [group](https://api.rubyonrails.org/classes/ActiveRecord/QueryMethods.html#method-i-group): performs sql `GROUP BY` on args. More info, [visit](spec/query_methods/group_spec.rb).
* [having](https://api.rubyonrails.org/classes/ActiveRecord/QueryMethods.html#method-i-having): performs sql `HAVING` on args. This method is used to perform conditions like sql `WHERE` but permits adding aggregate functions. Remember, this method requires your query to include `group`. More info, [visit](spec/query_methods/having_spec.rb).
* [distinct](https://api.rubyonrails.org/classes/ActiveRecord/QueryMethods.html#method-i-distinct): removes duplicated records according to the args passed. More info, [visit](spec/query_methods/distinct_spec.rb).

### Select fields
These methods when used, modify the select statement of a query from `SELECT * ...` to the arguments passed. There are currently 3 different ways:
 
* [select](https://api.rubyonrails.org/classes/ActiveRecord/QueryMethods.html#method-i-select): It returns `ActiveRecord::Relation` therefore it can be chained with other query methods.
* [pluck](https://api.rubyonrails.org/classes/ActiveRecord/Calculations.html#method-i-pluck): Returns an Array of the attribute values. If the resulting query returns more than one record from the db, it would be an Array of Arrays.
* [pick](https://api.rubyonrails.org/classes/ActiveRecord/Calculations.html#method-i-pick): It behaves like `pluck` but returns only one record using sql `LIMIT 1` underneath.

It is important to understand that neither `pluck` nor `pick` are chainable.

### Eager loading
* [preload](https://api.rubyonrails.org/classes/ActiveRecord/QueryMethods.html#method-i-preload): loads into memory the relation tables into separate queries. More info, [visit](spec/query_methods/preload_spec.rb).
* [eager_load](https://api.rubyonrails.org/classes/ActiveRecord/QueryMethods.html#method-i-eager_load): loads into memory the relation tables using a single SQL query. More info, [visit](spec/query_methods/eager_load_spec.rb).
* [includes](https://api.rubyonrails.org/classes/ActiveRecord/QueryMethods.html#method-i-includes): loads into memory the relation tables but it is smarter than `preload` when conditions on related tables are passed. More info, [visit](spec/query_methods/includes_spec.rb).

### Joining tables
* [joins](https://api.rubyonrails.org/classes/ActiveRecord/QueryMethods.html#method-i-joins): performs sql `INNER JOIN` on args. More info, [visit](spec/query_methods/joins_spec.rb).
* [left\_outer\_joins](https://api.rubyonrails.org/classes/ActiveRecord/QueryMethods.html#method-i-left_outer_joins): performs sql `LEFT OUTER JOIN` on args. It is behaviour used for eager loading methods such as `eager_load` and `includes`.

### Agregates

There are several methods used for mapping into [SQL aggregates](https://api.rubyonrails.org/classes/ActiveRecord/Calculations.html).

### Subqueries
A subquery is a query within a query. It permits increasing the expressive power of SQL. Subqueries can be used in different places inside of  statements such as `SELECT`, `WHERE`, `HAVING` or `EVEN`. Also in `UPDATE` or `DELETE`.

There are two types of subqueries:

* **simple:** where the inner query does not reference columns from the outer query and
* **correlated:** where the inner query references columns from the outer query. These type of queries tend to be slow since they imply many executions

We can benefit of subqueries through ActiveRecord using [from](https://api.rubyonrails.org/classes/ActiveRecord/QueryMethods.html#method-i-from). More info, please [visit](spec/query_methods/from_spec.rb).

## Data Models and associations

TBD


## Migrations

TBD


## Advanced

* Use [explain](https://api.rubyonrails.org/classes/ActiveRecord/Relation.html#method-i-explain) and [to_sql](https://api.rubyonrails.org/classes/ActiveRecord/Relation.html#method-i-to_sql) to get a sense of the plan executed and the SQL query generated respectively.
* Combine several SQL statements as one atomic action using [Transaction](https://api.rubyonrails.org/classes/ActiveRecord/Transactions/ClassMethods.html).
* [Optimistic](https://api.rubyonrails.org/classes/ActiveRecord/Locking/Optimistic.html)/[Pesimistic](https://api.rubyonrails.org/classes/ActiveRecord/Locking/Pessimistic.html) locking through ActiveRecord.
* Combine `ActiveRecord::Relation` using [merge](https://api.rubyonrails.org/classes/ActiveRecord/SpawnMethods.html#method-i-merge).
* Advanced ActiveRecord queries using private API [Arel](https://pganalyze.com/blog/active-record-subqueries-rails).

## Exercises
0. Prepare the environment for test: ```make test```.
1. Retrieve pricing_settings for domestic, i.e. whose currency is similar to the currency for a company, in a country given. [Implementation](app/queries/pricing_settings_for_domestic.rb) and [Test](spec/app/queries/pricing_settings_for_domestic_spec.rb). Hint: `where` and `joins` can be used.
2. Retrieve pricing_settings for exchange, i.e. whose currency differs from the currency for a company, in a country given. [Implementation](app/queries/pricing_settings_for_exchange.rb) and [Test](spec/app/queries/pricing_settings_for_exchange_spec.rb). Hint: `where` and `joins` can be used.
3. Retrieve companies having pricing\_settings whose payment\_method behind is from credit_card type. [Implementation](app/queries/companies_offering_credit_card.rb) and [Test](spec/app/queries/companies_offering_credit_card_spec.rb). Hint: `where`, `joins` and `distinct`.
4. Retrieve companies having pricing\_settings whose payment\_method behind is from credit_card type grouped by sector with totals. [Implementation](app/queries/companies_offering_credit_card_sector_counted.rb) and [Test](spec/app/queries/companies_offering_credit_card_sector_counted_spec.rb). Hint: `select`, `where`, `joins`, `distinct`, `group`, `count`.
5. Retrieve companies offering many pricing\_settings grouped by company and country code. When a company has more than one pricing_setting offered, it is considered many. [Implementation](app/queries/companies_offering_many_pricing_settings_per_country.rb) and [Test](spec/app/queries/companies_offering_many_pricing_settings_per_country_spec.rb). Hint: `group`, `having`, `pluck`.
6. There is an query [implementation](app/queries/company_offers_for_country.rb) together with [test](spec/app/queries/company_offers_for_country_spec.rb) that retrieves a list of pricing offers for a given company and country code given. Run the following commands:
	* ```$ make shell```
	* ```$ bin/console```
	* ```$ Queries::CompanyOffersForCountry.call```

	do you find anything suspicious in terms of queries executed? Could it be improved? Hint: `preload`, `includes` or `eager_load`.
7. Retrieve companies offering payment\_methods above average spread of pricing\_settings. [Implementation](app/queries/companies_offering_payment_methods_above_avg_spread.rb) and [Test](spec/app/queries/companies_offering_payment_methods_above_avg_spread_spec.rb). Hint: `select`, `joins`, `where`, `from` and `distinct`.
8. There is a need to re-compute pricing\_settings\_count for each and every company. [Implementation](tasks/companies.rake) and [Test](spec/tasks/companies_spec.rb). Hint: `.find_in_batches` and `#update_column` or `correlated subquery` and `.update_all`.


## References
* [Advanced ActiveRecord: Using Subqueries](https://pganalyze.com/blog/active-record-subqueries-rails)
* [Preload, eager_load, includes, joins](https://www.bigbinary.com/blog/preload-vs-eager-load-vs-joins-vs-includes)
* [Correlated Subquery in SQL](https://learnsql.com/blog/correlated-sql-subqueries-newbies/)
* [Creating Advanced Active Record DB Queries with Arel](https://www.cloudbees.com/blog/creating-advanced-active-record-db-queries-arel)

export async function up(knex) {
  return knex.schema.table('users', (table) => {
    table.boolean('is_admin').defaultTo(false);
  });
}

export async function down(knex) {
  return knex.schema.table('users', (table) => {
    table.dropColumn('is_admin');
  });
}

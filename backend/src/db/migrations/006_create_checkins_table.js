export async function up(knex) {
  return knex.schema.createTable('checkins', (table) => {
    table.uuid('id').primary().defaultTo(knex.raw('gen_random_uuid()'));
    table.uuid('hangout_id').notNullable().references('id').inTable('hangouts').onDelete('CASCADE');
    table.uuid('user_id').notNullable().references('id').inTable('users').onDelete('CASCADE');
    table.boolean('attended').defaultTo(false);
    table.text('reflection').nullable();
    table.timestamp('created_at').defaultTo(knex.fn.now());
    table.unique(['hangout_id', 'user_id']);
  });
}

export async function down(knex) {
  return knex.schema.dropTableIfExists('checkins');
}

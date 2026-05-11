export async function up(knex) {
  return knex.schema.createTable('hangouts', (table) => {
    table.uuid('id').primary().defaultTo(knex.raw('gen_random_uuid()'));
    table.uuid('group_id').notNullable().references('id').inTable('groups').onDelete('CASCADE');
    table.date('date').notNullable();
    table.string('time', 50).notNullable();
    table.string('location_name', 255).notNullable();
    table.string('location_address', 500).notNullable();
    table.jsonb('suggested_prompts').nullable();
    table.enum('status', ['upcoming', 'completed', 'cancelled']).defaultTo('upcoming');
    table.timestamp('created_at').defaultTo(knex.fn.now());
  });
}

export async function down(knex) {
  return knex.schema.dropTableIfExists('hangouts');
}

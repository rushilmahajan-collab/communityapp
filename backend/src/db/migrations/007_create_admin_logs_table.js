export async function up(knex) {
  return knex.schema.createTable('admin_logs', (table) => {
    table.uuid('id').primary().defaultTo(knex.raw('gen_random_uuid()'));
    table.uuid('admin_id').notNullable().references('id').inTable('users').onDelete('CASCADE');
    table.string('action', 100).notNullable();
    table.uuid('user_id').nullable().references('id').inTable('users').onDelete('CASCADE');
    table.string('severity', 20).nullable();
    table.text('reason').nullable();
    table.text('notes').nullable();
    table.timestamp('created_at').defaultTo(knex.fn.now());
  });
}

export async function down(knex) {
  return knex.schema.dropTableIfExists('admin_logs');
}

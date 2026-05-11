export async function up(knex) {
  return knex.schema.createTable('group_members', (table) => {
    table.uuid('id').primary().defaultTo(knex.raw('gen_random_uuid()'));
    table.uuid('group_id').notNullable().references('id').inTable('groups').onDelete('CASCADE');
    table.uuid('user_id').notNullable().references('id').inTable('users').onDelete('CASCADE');
    table.enum('role', ['member']).defaultTo('member');
    table.enum('status', ['active', 'requested', 'removed']).defaultTo('requested');
    table.timestamp('joined_at').defaultTo(knex.fn.now());
    table.unique(['group_id', 'user_id']);
  });
}

export async function down(knex) {
  return knex.schema.dropTableIfExists('group_members');
}

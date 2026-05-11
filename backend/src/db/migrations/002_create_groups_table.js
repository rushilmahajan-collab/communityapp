export async function up(knex) {
  return knex.schema.createTable('groups', (table) => {
    table.uuid('id').primary().defaultTo(knex.raw('gen_random_uuid()'));
    table.string('name', 255).notNullable();
    table.text('description').nullable();
    table.string('city', 100).notNullable();
    table.string('neighborhood', 100).nullable();
    table.float('latitude').notNullable();
    table.float('longitude').notNullable();
    table.string('meeting_day', 50).notNullable();
    table.string('meeting_time', 50).notNullable();
    table.string('meeting_location_name', 255).notNullable();
    table.string('meeting_location_address', 500).notNullable();
    table.integer('max_members').defaultTo(10);
    table.boolean('is_open').defaultTo(true);
    table.uuid('created_by').notNullable().references('id').inTable('users').onDelete('CASCADE');
    table.timestamp('created_at').defaultTo(knex.fn.now());
    table.timestamp('updated_at').defaultTo(knex.fn.now());
  });
}

export async function down(knex) {
  return knex.schema.dropTableIfExists('groups');
}

export async function up(knex) {
  return knex.schema.createTable('users', (table) => {
    table.uuid('id').primary().defaultTo(knex.raw('gen_random_uuid()'));
    table.string('first_name', 100).notNullable();
    table.string('email', 255).unique().notNullable();
    table.string('password_hash', 255).notNullable();
    table.string('profile_photo_url').nullable();
    table.string('neighborhood', 100).nullable();
    table.string('city', 100).notNullable();
    table.float('latitude').nullable();
    table.float('longitude').nullable();
    table.jsonb('quiz_responses').nullable();
    table.boolean('is_admin').defaultTo(false);
    table.timestamp('created_at').defaultTo(knex.fn.now());
    table.timestamp('updated_at').defaultTo(knex.fn.now());
  });
}

export async function down(knex) {
  return knex.schema.dropTableIfExists('users');
}

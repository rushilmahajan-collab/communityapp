export async function seed(knex) {
  const prompts = [
    "What's something you're proud of that you don't talk about enough?",
    "What's been on your mind lately that you haven't said out loud?",
    "What's a lesson you learned the hard way?",
    "Who's someone that changed your life, and do they know it?",
    "What would you do differently if you could start over in this city?",
    "What does a good friend look like to you?",
    "What's something you need help with right now?",
    "What's the best meal you've ever had, and who were you with?",
    "What are you most excited about in your life right now?",
    "If your group could do one thing together this month, what should it be?",
    "What's one thing you wish more people understood about you?",
    "Tell us about a time you felt truly seen by someone.",
    "What does showing up mean to you?",
    "What's something you've recently changed your mind about?",
    "Who in your life makes you want to be better, and why?",
  ];

  return knex.raw(`
    CREATE TABLE IF NOT EXISTS conversation_prompts (
      id SERIAL PRIMARY KEY,
      prompt TEXT NOT NULL
    );
    DELETE FROM conversation_prompts;
  `).then(() => {
    return knex('conversation_prompts').insert(
      prompts.map((prompt) => ({ prompt }))
    );
  });
}

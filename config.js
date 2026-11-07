export function config(env) {
  const required = ['BOT_TOKEN','WEBHOOK_SECRET'];
  for (const key of required) if (!env[key]) throw new Error(`Missing secret: ${key}`);
  return {
    token: env.BOT_TOKEN, webhookSecret: env.WEBHOOK_SECRET,
    adminId: String(env.ADMIN_TELEGRAM_ID || '8952746307'), adminUsername: env.ADMIN_USERNAME || 'P10N33RR',
    channelId: env.CHANNEL_ID || '', channelUsername: env.CHANNEL_USERNAME || 'cocpioneernews',
    clanLink: env.CLAN_LINK || '', accountEnabled: env.ACCOUNT_LISTINGS_ENABLED === 'true',
    maxClanMembers: Number(env.MAX_CLAN_MEMBERS || 50), botUsername: env.BOT_USERNAME || 'cocagahibot'
  };
}

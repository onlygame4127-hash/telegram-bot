const {BOT_TOKEN,WEBHOOK_SECRET,WORKER_URL}=process.env;
if(!BOT_TOKEN||!WEBHOOK_SECRET||!WORKER_URL){console.error('BOT_TOKEN, WEBHOOK_SECRET, WORKER_URL are required');process.exit(1);}
const url=`https://api.telegram.org/bot${BOT_TOKEN}/setWebhook`;
const response=await fetch(url,{method:'POST',headers:{'content-type':'application/json'},body:JSON.stringify({url:`${WORKER_URL.replace(/\/$/,'')}/telegram/webhook`,secret_token:WEBHOOK_SECRET,allowed_updates:['message','callback_query']})});
const data=await response.json();if(!response.ok||!data.ok){console.error('Webhook setup failed:',data.description||response.status);process.exit(1);}console.log('Webhook configured:',data.result);

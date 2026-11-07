export class Telegram {
 constructor(token){if(!token)throw new Error('BOT_TOKEN missing');this.base=`https://api.telegram.org/bot${token}`;}
 async call(method,payload={}){const r=await fetch(`${this.base}/${method}`,{method:'POST',headers:{'content-type':'application/json'},body:JSON.stringify(payload)});const d=await r.json().catch(()=>({}));if(!r.ok||!d.ok)throw new Error(`Telegram ${method}: ${d.description||r.status}`);return d.result;}
 sendMessage(chat_id,text,extra={}){return this.call('sendMessage',{chat_id,text,...extra});}
 sendPhoto(chat_id,photo,caption,extra={}){return this.call('sendPhoto',{chat_id,photo,caption, ...extra});}
 editMessageCaption(chat_id,message_id,caption,extra={}){return this.call('editMessageCaption',{chat_id,message_id,caption,...extra});}
 editMessageMedia(chat_id,message_id,media,extra={}){return this.call('editMessageMedia',{chat_id,message_id,media,...extra});}
 editMessageReplyMarkup(chat_id,message_id,reply_markup){return this.call('editMessageReplyMarkup',{chat_id,message_id,reply_markup});}
 answerCallbackQuery(callback_query_id,text=''){return this.call('answerCallbackQuery',{callback_query_id,text});}
 getMe(){return this.call('getMe');}
 setWebhook(url,secret_token){return this.call('setWebhook',{url,secret_token,allowed_updates:['message','callback_query']});}
 deleteWebhook(){return this.call('deleteWebhook');}
}

export function normalizeDigits(value=''){return String(value).replace(/[۰-۹]/g,d=>String('۰۱۲۳۴۵۶۷۸۹'.indexOf(d))).replace(/[٠-٩]/g,d=>String('٠١٢٣٤٥٦٧٨٩'.indexOf(d))).replace(/[٬،]/g,'').replace(/,/g,'').trim();}
export function integer(value,{min=0,max=Number.MAX_SAFE_INTEGER}={}){const s=normalizeDigits(value);if(!/^\d+$/.test(s))return null;const n=Number(s);return Number.isSafeInteger(n)&&n>=min&&n<=max?n:null;}
export function safeText(value,max=80){const s=String(value??'').trim();if(!s||s.length>max||/[\u0000-\u001F\u007F]/.test(s))return null;return s;}
export function price(value){return integer(value,{min:1,max:2_000_000_000});}
export function makeCode(prefix){const alphabet='ABCDEFGHJKLMNPQRSTUVWXYZ23456789';const b=crypto.getRandomValues(new Uint8Array(6));return `${prefix}-${[...b].map(x=>alphabet[x%alphabet.length]).join('')}`;}
export function validTag(v){const s=safeText(v,32);return s&&/^[#A-Za-z0-9]+$/.test(s)?s:null;}
export function htmlEscape(v=''){return String(v).replace(/[&<>]/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;'}[c]));}

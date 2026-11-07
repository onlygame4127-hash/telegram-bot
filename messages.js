export const welcome=name=>`سلام ${name||'دوست عزیز'} عزیز، خوش اومدی🌹🌹`;
export const money=n=>Number(n||0).toLocaleString('en-US');
export const statusFa=s=>({draft:'پیش‌نویس',pending_review:'در انتظار بررسی',revision_requested:'درخواست اصلاح',approved:'تأیید شده',publishing:'در حال انتشار',published:'منتشرشده',rejected:'ردشده',sold:'فروخته‌شده',unavailable:'ناموجود',cancelled:'لغوشده',archived:'بایگانی‌شده',publish_failed:'خطای انتشار',update_failed:'خطای به‌روزرسانی'}[s]||s);

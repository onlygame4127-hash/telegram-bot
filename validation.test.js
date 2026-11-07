import test from 'node:test';
import assert from 'node:assert/strict';
import {normalizeDigits,integer,price,safeText,validTag,makeCode} from '../src/services/validation.js';
test('Persian and Arabic digits normalize',()=>{assert.equal(normalizeDigits('۱۲۳٤٥'), '12345');assert.equal(integer('۱۲۳',{min:1}),123);});
test('integer boundaries and invalid input',()=>{assert.equal(integer('0',{min:0}),0);assert.equal(integer('-1'),null);assert.equal(integer('1.2'),null);assert.equal(integer('999',{max:10}),null);});
test('price must be positive',()=>{assert.equal(price('۰'),null);assert.equal(price('-20'),null);assert.equal(price('۱۲۳٬۴۵۶'),123456);});
test('safe text rejects control chars and oversized input',()=>{assert.equal(safeText('Dragon123'), 'Dragon123');assert.equal(safeText('  '),null);assert.equal(safeText('x\nY'),null);assert.equal(safeText('x'.repeat(81)),null);});
test('tags accept game tag characters only',()=>{assert.equal(validTag('#2LCP90URY'),'#2LCP90URY');assert.equal(validTag('bad tag'),null);assert.equal(validTag('تگ'),null);});
test('ad codes have expected prefix and alphabet',()=>{const c=makeCode('ACC');assert.match(c,/^ACC-[A-HJ-NP-Z2-9]{6}$/);});

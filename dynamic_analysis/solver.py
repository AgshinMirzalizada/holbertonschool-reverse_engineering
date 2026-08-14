from z3 import *

# 1. Z3 Həlledicisini yaradırıq
s = Solver()

# 2. 24 ədəd 8-bitlik simvolik dəyişən
chars = [BitVec(f'c_{i}', 8) for i in range(24)]

# 3. MƏHDUDİYYƏT DÜZƏLİŞİ:
# Simvolların yalnız kiçik hərf, rəqəm, '_' və '?' olmasını tələb edirik.
# Bu, riyazi toqquşmaların (collisions) qarşısını alır.
for c in chars:
    s.add(Or(
        And(c >= ord('a'), c <= ord('z')),
        And(c >= ord('0'), c <= ord('9')),
        c == ord('_'),
        c == ord('?')
    ))

# İlkin dəyişənlər
local_54 = BitVecVal(0, 32)
local_50 = BitVecVal(1, 32)
local_4c = BitVecVal(0, 32)
local_48 = BitVecVal(1, 32)

# 4. FOR dövründəki tənliklər
for local_44 in range(24):
    iVar1 = ZeroExt(24, chars[local_44])
    
    local_54 = local_54 + ((local_44 + 1) * iVar1 * (local_44 + 2)) % 0x100
    local_50 = ((iVar1 + local_44 * 7 + 0x1f) % 0x7b) * local_50
    local_4c = local_4c + ((local_44 + 1) * iVar1 + local_44 * local_44) % 0x200
    local_48 = local_48 ^ ((local_44 + 3) * iVar1 + 0x11) % 0x400

# 5. Yekun yoxlama şərti (bVar3 hesablanması)
term1 = local_54 * local_50
term2 = (((local_4c + term1) - local_48) ^ 0xdeadbeef) & 0xffffff
final_expr = (((term1 + term2) - local_4c * local_48) + 0xcafebabe) % 0xf1206

s.add(final_expr == 0xae44)

print("Həll edilir, xahiş olunur gözləyin...")

# 6. Həlli hesablamaq
if s.check() == sat:
    m = s.model()
    extracted = "".join([chr(m[c].as_long()) for c in chars])
    print("\n[+] Cavab Tapıldı!")
    print(f"FLAG: Holberton{{{extracted}}}")
else:
    print("Həll tapılmadı.")
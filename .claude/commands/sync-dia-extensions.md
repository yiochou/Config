Scan all installed Dia extensions and sync the `DIA_EXTENSIONS` list in `install.sh`.

## Step 1 — Scan installed extensions

Run this script to get the current state:

```bash
python3 << 'EOF'
import json, os

ext_dir = os.path.expanduser('~/Library/Application Support/dia/User Data/Default/Extensions')

def get_name(eid):
    try:
        for ver in os.listdir(f'{ext_dir}/{eid}'):
            mpath = f'{ext_dir}/{eid}/{ver}/manifest.json'
            if not os.path.exists(mpath):
                continue
            with open(mpath) as f:
                m = json.load(f)
            name = m.get('name', '')
            if name.startswith('__MSG_'):
                key = name[6:-2]
                for locale in ['en', 'en_US']:
                    lpath = f'{ext_dir}/{eid}/{ver}/_locales/{locale}/messages.json'
                    if os.path.exists(lpath):
                        with open(lpath) as f:
                            msgs = json.load(f)
                        for k, v in msgs.items():
                            if k.lower() == key.lower():
                                return v['message']
            return name
    except Exception:
        pass
    return ''

if not os.path.exists(ext_dir):
    print("ERROR: Dia Extensions folder not found")
else:
    for eid in sorted(os.listdir(ext_dir)):
        if eid == 'Temp':
            continue
        name = get_name(eid)
        if name:
            print(f'{eid}\t{name}')
EOF
```

## Step 2 — Parse current install.sh

Read `install.sh` in the current working directory (should be the Config repo). Extract all entries in the `DIA_EXTENSIONS` array — each line looks like `"Name:id"`.

## Step 3 — Show diff

Compare the two lists (by extension ID) and display:

```
── Dia extensions diff ──
  ✚ <name>   (installed, not tracked)
  ✖ <name>   (tracked, no longer installed)
  ● <name>   (unchanged)
```

If there are no changes, say so and stop.

## Step 4 — Ask for confirmation

Ask: **"Apply these changes to install.sh? (y/n)"**

If the user says no, stop.

## Step 5 — Update install.sh

Replace the `DIA_EXTENSIONS` array in `install.sh` with the new list.
- Keep the format: `"Display Name:extension_id"`
- Sort entries alphabetically by display name
- Preserve all other parts of the file exactly

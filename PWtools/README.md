In Linux, pwtools parses well. But it failed in mac os.
I found the problem is caused by the parse.py (e.g. /Users/ywfang/miniconda3/envs/plotenv/lib/python3.7/site-packages/pwtools/parse.py)
This following line doesn't work in mac:
sed -re 's/.*=\s+([0-9]+).*/\1/'" %self.filename
when I have time, I will make it run in mac.

Ref: sed -Ee (https://gitlab.lam.fr/etc42/etc42-docker-python/-/commit/53f23fe27f2ad18f54d9e66d7a70e69b3df21b0b)

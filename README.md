# Cloudflare - Turnstile Solver Using Camoufox⁠
```
docker run -d \
  --name turnstile-solver \
  --restart unless-stopped \
  -p 5000:5000 \
  -e BROWSER_TYPE=camoufox \
  -e HEADLESS=True \
  -e THREAD=10 \
  -e HOST=0.0.0.0 \
  -e PORT=5000 \
  -e PROXY=False \
  ***/turnstile-solver-camoufox:***
```
# Using proxies.txt

+ touch $(pwd)/proxies.txt
```
protocol://ip:port:username:password
protocol://ip:port
```
+ then run:
```
docker run -d \
  --name turnstile-solver \
  --restart unless-stopped \
  -p 5000:5000 \
  -v $(pwd)/proxies.txt:/app/proxies.txt \
  -e BROWSER_TYPE=camoufox \
  -e HEADLESS=True \
  -e THREAD=10 \
  -e HOST=0.0.0.0 \
  -e PORT=5000 \
  -e PROXY=True \
  ***/turnstile-solver-camoufox:***
```
sources and instructions from https://github.com/Theyka/Turnstile-Solver.git⁠
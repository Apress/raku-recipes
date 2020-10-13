import requests
import sys

if len(sys.argv) > 1:
    ingredient = sys.argv[1]
else:
    ingredient = "Rice"

with requests.get('http://localhost:31415/Ingredient/'+ingredient) as r:
    if (r.status_code == 200): 
        print(r.text)


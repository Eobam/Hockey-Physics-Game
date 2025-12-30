import json

# Read from file and parse JSON
with open("pos.json", "r") as f:
    data = json.load(f)

print(data)
print(type(data))
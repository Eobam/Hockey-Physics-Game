from openrouter import OpenRouter
import json


client = OpenRouter(
    api_key="sk-hc-v1-30f1d55ebb0c44158bb67f50134fee65bb52a60169c248c4a004dfac70ac64d3",
    server_url="https://ai.hackclub.com/proxy/v1",
)
json.load("pos.json")

response = client.chat.send(
    model="qwen/qwen3-32b",
    messages=[
        {"role": "user", "content": "You are a bot in a hockey game where your character bounces the puck into the net."
         "You are a the following position: "
         "The puck is at the following position:"
         "Choose the best possible move, reply with 'left' to move left, 'right' to move right, 'up' to move forward, 'down' to move backwards. DO NOT REPLY WITH ANYTHING ELSE. "
         "When movement begins, you are incredibly slow, the longer you hold a "
         }
    ],
    stream=False,
)

print
print(response.choices[0].message.content)
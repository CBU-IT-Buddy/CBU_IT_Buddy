import torch
from transformers import AutoTokenizer, AutoModelForCausalLM

#Load the pre model and tokenizer

tokenizer = AutoTokenizer.from_pretained("gpt2")

model = AutoModelForCausalLM.from_pretrained("gpt2")

with open("training_data.txt", "r") as f:
  training_data = f.readlines()

#Tokenizeing the pdf
input_ids=[]
for text in training_data:
  encoded_text = tokenizer.encode(text, return_tensors = "pt")
  input_ids.append(torch.tensor(encoded_text))

#Create PyTorch Ladder

batch_size = 16
max_length = 4096
dataset = torch.utils.data.ConcatDataset(input_ids)
dataloader = torch.utils.data.DataLoader(input_ids, batch_size=batch_size, shuffle=True)
#training the model
from transformers import AdamW

optimizer = AdamW(model.parameters(), lr=5e-5)

num_epochs = 10
for epoch in range(num_epochs):
  for batch in dataloader:
    batch = batch.to(device)
    outputs = model(batch, labels=batch)
    loss = outputs.loss
    loss.backward()
    optimizer.step()
    optimizer.zero_grad()
  print(f"Epoch {epoch+1}/{num_epochs} - Loss: {loss.item():.4f}")

model.save_pretained("Trained_IT_buddy")
#Evaluation Portion
from sklearn.metrics import accuracy_score, precision_score, recall_score, f1_score, confusion_matrix
#perplexity scores

perplexity_values = []

for sample in dataset:
  input_ids = tokenizer.encode(sample["text"], return_tensors="pt")
  outputs = model(input_ids, labels=input_ids)
  loss = outputs.loss
  perplexity = torch.exp(loss)
  perplexity_values.append(perplexity.item())

average_perplexity = sum(perplexity_values) / len(perplexity_values)
print("Avg perplexity score: ",average_perplexity)

#BLEU score

bleu_scores = []

for example in dataset:
  input_ids = tokenizer.encode(example["text"], return_tensors="pt")
  generated_text = model.generate(input_ids, max_length=2000)
  generated_text_string= tokenizer.decode(generated_text[0], skip_special_tokens=True)
  bleu_score = calculate_bleu(example["text"], generated_text_string)
  bleu_scores.append(bleu_score)

average_bleu_score = sum(bleu_scores) / len(bleu_scores)
print("Avg BLEU score: ", average_bleu_score)
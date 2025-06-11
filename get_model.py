import torch

# ('pytorch/vision:v0.10.0', 'resnet152'),
# ('huggingface/pytorch-transformers', 'model', 'bert-base-uncased'),
# ('huggingface/transformers', 'modelForCausalLM', 'gpt2'),
# ('pytorch/vision:v0.10.0', 'vgg19'),
# ('huggingface/transformers', 'modelForCausalLM', 'gpt2-large'),
# ('huggingface/transformers', 'modelForCausalLM', 'gpt2-xl'),

model = torch.hub.load('pytorch/vision:v0.10.0', 'vgg19', pretrained=True)

torch.save(model, './model.pth')
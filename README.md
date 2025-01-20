# FPGA-LeNet  
## Introduction
<img width="1280" alt="26f18f0402cb267395cdc86520be4ad" src="https://github.com/user-attachments/assets/509d6116-e411-4667-adb1-d5b80c52ad30" />


A FPGA implementation of LeNet, simulated on Vivado.  
This version is according to *LeNet-5: Gradient-Based Learning Applied to Document Recognition*.    
**The computational paradigm of convolutional neural networks is complete**, but the accuracy is only reserved to float16, the convolutional calculation will overflow in the final accumulation step, resulting in inaccurate results.  
This project is still updating and you can look forward to the next version!  

## Implementation Details
<img width="1010" alt="b0343dd1bcb78b5f63c1a360b8b3091e" src="https://github.com/user-attachments/assets/a061ad74-d9d0-4a4d-9f87-b80c8c627a3d" />
Convolution Layer
<img width="1049" alt="2a29d9f545afc59621249d41fca12288" src="https://github.com/user-attachments/assets/6c742b7a-b3a6-470e-815d-ba0c7a218819" />
Pooling Layer (Average Pooling)
<img width="1039" alt="86847f6d1ae0bc1f0005bc2a16a82b35" src="https://github.com/user-attachments/assets/6874353d-6236-42e5-8437-ea193a6791ea" />
Linear Layer
<img width="1010" alt="cfb36aee6d3b6a0fd2b062d2e6c321eb" src="https://github.com/user-attachments/assets/c96f4b5d-d974-4eb5-9f1c-cc5815d79bc0" />
Sigmoid Layer
<img width="1120" alt="7835ed11de682af0220501ad1ca19c4e" src="https://github.com/user-attachments/assets/0bea2f53-fb9c-47d7-ab0e-0f86415e2fe6" />
Softmax Layer

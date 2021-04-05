# Introduction 

In our previous module we got an introduction to some machine learning concepts including modeling, supervised training, and classification. Machine learning, and deep learning are obviously increasingly big fields tackling an ever-increasing variety of problems. So far, we have learned about models that take in numerical input of a specific size and output predictions about individual data points. We had individual observations (cell lines) that we had a fixed number of input features for (individual genes). We then use those to create one or more classifications for each cell line. This sort of setup is the most common setup in machine learning. 

Even applications you might think of as more complicated, like image recognition, frequently operate on the same principal. Basic image recognition models may just treat a fixed-size images as arrays of values, one for each pixel. The importance of a particular pixel value is really only relevant in the context of all of the pixels around it in a particular pattern. Image recognition models use functions like convolution to enable the model to take into account the context an individual feature is in. 

In our stream we have an ongoing project where we seek to apply deep learning techniques to biological sequences like genes or genomes. Unlike a transcriptome pattern or a fixed-size image, genes and genomes come in all sorts of lengths. There are not really ways to "resize" a gene like you might an image. What type of models might we use to teach machines to "learn" about these types of sequences?

The approach we take is to borrow methods from a field known as **natural language modeling (NLM)** or **natural language processing (NLP)**. Natural language models are used whenever we need a computer to work with human language. Whether it is your phone performing voice recognition to turn an audio recording of your voice into a command that can be interpreted, a customer-service chatbot attempting to help you, or a tool to parse sentiment from tweets, some sort of language model is working the background. Natural language models work by breaking down human language into individual **tokens**, which could be letters, words, or word fragments. These models catalog every possible token they might need to know about, and represent language as a sequence of numerical tokens. 

Models used for NLP work by using functions that are effective in taking into account the sort of context-dependent meaning our words have. Take, for instance, the word "sentence". There are two major meanings: the grammatical construct and the judical concept. Which is meant depends on both local context, other words in the sentence, but might also depend on global context, words in the rest of the body of text, like paragraph, article, or book. The reason we choose to use NLM for our biological sequence learning is because we can interpret this as a metaphor for how biological sequences work. Much like human language, genes are also one dimensional sequences made up of individual building blocks. Like letters or words, the "meaning" of a particular amino acid or gene is not fixed. A lysine in a protein may do very different things depending on the neighboring amino acids, which determine what type of local secondary structure it is in, whether it is on the inside or outside of a protein. There are effects of both local and global context on individual elements of a biological sequence. Since NLP models are designed to look for these sorts of interactions, but not in any way hard-coded to represent real langauges, they can fairly be used for "biological language" just as well!

In this walkthrough we are going to step through, at a relatively low level, the process of using a modern deep neural network, known as a Transformer network, to build a model to predict protein secondary structure from raw sequences.

# "Embedding" a sequence into a form suitable for deep learning

Hopefully by this point you have, correctly, gotten the impression that machine learning is built on math and needs numbers to work. When we work with categorical data, we have to convert it to numbers, but carefully. If we have three categories: red, blue, and yellow, we might represent them as 0, 1, and 2 for modeling. We need to be careful, because how we represent our data as numbers might build in certain assumptions. If we were to treat these as true numbers, we would assume that 0 and 1 are "closer together" or more similar than 0 and 2, but red and blue aren't necessarily any more similar than red and yellow. 

How do we avoid this? There are a variety of ways to represent these categories by **embedding** them in more dimensions. One common method used in machine learning is called "one-hot encoding". In this scheme, we would represent each of the three categories with a 3-vector. Red might be [1 0 0], blue might be [0 1 0], and yellow [0 0 1]. This way each representation is "orthogonal" and equally-different from each other representation. 

When we represent words, or amino acids, we want to be careful about what assumptions we are building in. NLM models take the same approach of representing each possible token as a different vector, but especially for language models where you might have tens of thousands of possible word tokens, using 40,000-dimensional vectors might become infeasible. Instead, they use "embedding" functions to represent each as a specific vector, not necessarily all orthogonal. If done carefully, this can create some *good* assumptions. You might create embeddings where words with similar meaning have vectors that are more similar, or embeddings where verbs are more similar to each other than they are to nouns. These might help kickstart the models.

## The BERT Way

There are quite a few ways to embed tokens as vectors, including the venerable word2vec. You can generate specific embeddings for specific words ahead of time and use them in your model. A recent NLM Transformer model, BERT, takes a different approach. Instead of predetermined vectors for each token, BERT *learns* the embedding for each token as it is trained on a task. The embedding of each token is a **parameter** in the BERT model that can be changed to result in better task performance. We will see what this looks like. 

### Tokenizing

First, we need to **tokenize** our sequences. Unlike human language, which may have hundreds of thousands of infrequently used words, new words, abbreviations, or slang that might need to be represented as word fragments or letters, protein sequences have a nice, fixed, set of possibilities. In addition to the 20 standard amino acids, we have a few extra symbols or ambiguity codes. We also want to use a few tokens to represent special features like the beginning or end of a seequence, or padding tokens to make the sequence a specific size. All in all, we will use 30 different tokens:

--CODE

In order to actually tokenize our sequence, we just look up each letter in the sequence and replace it with the corresponding integer in our table, and add the beginning and end tokens:

--CODE

#### Question 1

Q

### Embedding

As we mentioned before, using raw integers creates some misleading assumptions about similarity. An alanine (A, 5) is not more similar to cysteine (C, 7) than it is to glycine (G, 11). In fact, the opposite is true! We will replace each token with a **vector representation**. Because this is so common, PyTorch includes a **module** to do just this. the `nn.Embedding` module creates enough trainable parameters to replace each of the *first argument* number of tokens with vectors of length *second argument*. Here we create embeddings to turn each of 30 tokens into a distinct vectors each of length 128.

--CODE

In order to actually embed our tokens, we need to convert our tokens to a special type of data structure called a **tensor**. Tensors are a lot like (multi-dimensional) arrays, but include extra special features to enable training that we will talk about later. We can convert our tokens (a list of integers) to a tensor this way:

--CODE

We need to tell PyTorch to make this a `long` datatype. In this case, since we have categorical data, we want it represented as integers, instead of the default floating-point values. PyTorch in general likes 4-byte "long" integers. We also call a specific method, `unsqueeze()` here. This tweaks the "shape" of the tensor array to introduce an extra dimension.

#### Question 2

Unsqueeze and shapes

#### PyTorch modules

To actually embed our sequences we use our `Embedding` module like a function:

--CODE

PyTorch modules are objects that both contain trainable parameters as well as the code that uses them as functions. When we call our `embedding` object like a function, it uses its built-in parameters to replace each token with a vector!

#### Question 3

What shape is the output tensor? How did this change from the input tensor? What happened to the original tokens?

#### Question 4

Take a look at the original sequence. The first and fifth amino acids are both methionines (M). You can access these in our tensors by indexing like `tok_seq_tensor[0][1]` and `tok_seq_tensor[0][5]`. What relationship do the vectors representing these amino acids in `embedded_seq` have?

# Learning sequence context

Right now we have a rich representation of our sequence. We still have a sequence of (roughly) the same length as our original sequence, but each letter is now a big numerical vector of (currently random) numbers. As we discussed earlier, the "meaning" of our amino acids is different depending on which protein it is in, where it is in the protein, and the surrounding amino acids. Transformer models use a mathematical function known as **attention** to allow information to flow between different positions in a sequence. Attention creates relationships between different positions in a sequence to share information from earlier layers in the network. BERT is an **encoder model** that is made by stacking alternating layers of attention and standard feed-forward neurons.

## Using Transformers

We aren't going to implement a Transformer ourselves (at least in this assignment). There is an excellent Python library simply called [Transformers](https://huggingface.co/transformers/index.html) made by a company called HuggingFace 🤗. The Transformers library includes a wide selection of Transformer models with a similar API and a database of pre-trained language models.

We will use the HuggingFace implementation of BERT. First, we need to install Transformers:

--CODE

Next, to create a BERT encoder model, we need two pieces, the model module itself, and a special configuration object we use to select hyperparameters for the BERT network.

--CODE

To create the model, we instantiate a `BertConfig` object with a few parameters to make the network a bit smaller and manageable for this walkthrough. Next, we create a `BertConfig` module with the configuration:

--CODE

This `BertModel` is a PyTorch module just like our `Embedding` module was. This includes many (*many*) trainable parameters for each layer in the model and is called like a function to generate **contextual representations** of our sequence. In this case, we need to specific our input as for the parameter `inputs_embeds`. By default BERT actually performs embedding in a way that is designed for human language, but we did this ourselves for protein sequence. Fortunately, `BertModel` can accept already-embedded input this way:

--CODE

The output from `BertModel` is not actually just one tensor like with embeddings. Instead, it outputs a dictionary with multiple outputs. By default, this model outputs a **sequence representation** called `"last_hidden_state"` and a **pooled representation** called `"pooler_output"`. 

#### Question 5

What shape are each of the two outputs? Which one contains contextual representations for our amino acids? How many representations does the other output have? What biological object would this represent?

## Using contextual representations for learning

In this walthrough we are going to do **supervised learning** like we did in module 3. We want to teach our model to take in raw protein sequences (or at least tokenized sequences) and predict something biologically useful. In our example we are going to predict **protein secondary structure**.

### Protein secondary structure

When a protein strand is made, it doesn't stay elongated as a single strand. It folds up on itself like a piece of string does if you squished in into a ball in your hand. Unlike string, proteins don't fold randomly. They first form "secondary structure" where different parts of the strand might form spirals called **helices** or flat strands called **sheets**. This secondary structure then influences how the different section fold up in three dimensions to form **tertiary structure** which ultimately determines what a protein does. 

We are going to teach our model to predict, for each amino acid in our protein, whether it will form into a helix or not. You cannot simply look at once amino acid at a time, a methionine may or may not be in a helix, whether it is depends on the amino acids around it. This is exactly the sort of thing Transformers should be good at!

We have **target data** that is a second sequence, the same length as our protein sequence, with an `H` if the corresponding amino acid is in a helix and a `-` if it is not. 

--CODE

We need to convert this to a tensor in the same manner we did our tokenized protein sequence:

--CODE

#### Question 6

Find your two methionines you have hopefully become familiar with in this secondary structure. Do they both form the same type of secondary structure?

### ANNs at every level...

Once we have the target data, we have what we want our model to output. Our complete model should take in tokenized protein sequences and output predictions. We are going to have our model output **scores** for each of the possible secondary structures which we can interpret as probabilities of being each class. Since our BERT model outputs vectors of length 128, we cannot use this directly. Instead, we need to add another model or **head** to the model to do the actually classification using the contextual representations BERT outputs. 

We will use a simple, single hidden layer convolutional network for this, and in this case we will implement it ourselves!

--CODE

In this code we make a PyTorch module class. We define one `main` submodule that is a sequential combination of three steps. First, we take our input data and apply a convolution to transform it from size `in_dim` (128 in our case) to `hid_dim` (hidden layer dimension). We then apply a neuron activation function, in this case ReLU or a **Re**ctified **L**inear **U**nit. Finally, we convolve the data again to transform it to `out_dim` which will correspond to the number of different labels we have (two). The output of this function will be interpreted as two scores, one for each class.

To create the module we simply instantiate it like before with our dimensions:

--CODE

and classify our data by calling it with our BERT output!

--CODE

#### Question 7

Take a look at the output for your friendly methionines. Do these look like probabilities?

### Loss Functions

To decide whether or not our model is doing a good job of classifying our amino acids, we need a way to compare our models output to the "right answers". We do this using a **loss function**. Loss functions are functions that take in the predictions and the right answers and output a single, **scalar** value that is lower the more "correct" the predictions are. Ideally, perfect predictions experience no "loss" relative to the correct answers so the loss would be 0. The more data is "missing" from the predictions, the higher the loss.

For this type of classification, comparing scores for class labels to class labels, we use a function called **cross-entropy**. This measures how much information is lost when comparing two probability distributions. When we optimize our model to minimize this loss function, it will make our classifier output reprsent something like the probabilities for each class-helix vs not-helix.

--CODE

We need to specify `ignore_index=-1` to tell the loss function to ignore the first and last positions where we put -1 as the class since these special start/end tokens aren't amino acids and don't have secondary structure.

We calculate the loss value by calling the loss function with the predicted scores and the target true values:

--CODE

# Optimization

## Parameters

We've created a model that is capable of taking in tokenized protein sequences and outputing predictions for secondary structure. This model is made up of three **modules**, one for embedding, one for contextual transformation, and one for classification. Each of these models has parameters which can be trained to teach it to *understand* protein sequences to some degree and successfully predict the structure. 

We can extract the parameters from a module by calling the `parameters()` method. This returns an **iterable** of all the parameters. You can call `list()` on the resulting iterable to turn it into a list. Each element in this list is a PyTorch tensor, which can be a single scalar value, an linear array, or a multi-dimensional array. The number of individual parameters in a 30 x 128 dimensional array is 3840. By having lots of large matrices as parameters, you can quickly scale up the number of paramters in your model! You can check the size of these by calling the `size()` method of them.

--CODE

#### Question 8

How many individual parameters (individual numbers) are there in each of our three modules? How did you calculate this?

## Neural network training

The breakthroughs that led to neural networks changing from a mathematical curiosity from the 50s to a widely-exploited tool able to be (relatively) quickly and efficiently trained to do a huge variety of tasks concern how we tune the many parameters determining the behavior of each neuron in the network. Our network has a large number of parameters across the three modules. Using traditional optimization techniques on these millions of parameters would get us nowhere quickly. 

The concept that allows us to actually train these models is called **backpropogation**. I'm not going to go in depth on this. The basics is that as big as our network is, it can be thought of as a single function to map input to output with a variety of parameters.

For those of you who have much calculus: backpropogation is a process where you calculate the gradient, or partial derivative, of your function output relative to all of your function/network parameters. If you calculate these gradients, which are directional vectors, from your loss value, you effectively get a direction that you can move your parameter to make the loss value lower, and hence your model better.

For those of you without much calculus: backpropogation allows you to calculate which direction in which to change each parameter in your model to best make the model better.

### Backpropogation and tensors

Backpropogation is a process where you basically apply the chain rule over and over and over to the individual pieces of the composite function that is your model to get the derivative. Our models are huge and have millions of steps. The thing that makes this possible happens behind the scenes when we use PyTorch *tensors*. The special sauce tensors supply is the ability to track every calculation that happens using them. As we pass our tensors through our model, PyTorch creates as **computational graph** tracking every operation. Once we have our loss value, we can ask PyTorch to step backward through this graph from the loss value to calculate the gradient of every parameter involved. Understandably, this involes a lot of computation and is why deep learning models need expensive hardware capable of lots of very fast, very parallel math.

Actually doing the backpropogation and calculating gradients is made incredibly simple by PyTorch:

--CODE

When you call `backward()` PyTorch stores the gradient information inside each parameter tensor. 

### Optimizing a model

To train our model, we need to update our parameters. To do this, we need a scheme to accept parameter gradients and decide what new values to set our parameters to. We do this with an **optimizer**. There are different algorithms available to do this. One of the common methods is called **stochastic gradient descent**. As this name might imply, this process somewhat-randomly moves parameters down in the direction of their gradient. We can create an SGD optimizer in PyTorch by instantiating a `torch.optim.SGD` object with the parameters of our model and a learning rate telling it how much to update the parameters each step.

--CODE

Much like backpropogation, performining an optimization step is made incredibly simple:

--CODE

We just began the process of optimizing our model! If we repeat the modeling, loss calculation, and optimization stpe, we should see our loss value go down!

--code

### Iterative optimization

Training a neural network can take hundreds, thousands, or even millions of steps. We do this in an iterative fashion, feeding the network new data, calculating gradients, updating parameters, and repating indefinitely! We do this for either a fixed number of steps or until we are happy with the performance of our model. Here, we can make a simple for loop to repeat our process 100 times and store the loss values at each step:

--CODE

And plot the loss function values...

--CODE

Our model learns! The loss value pretty steadily drops until it reaches a quite low value.

At this point, we should take a look at what our model is outputing. As we saw before, our classifier outputs **scores** not actual probabilities. These numbers can be outside the range of 0..1, or even negative! We can convert these scores to probabilities using a function called **softmax** that represents these scores as a series of probabilities for each class adding up to one. We are going to run our model again to generate scores and then call `softmax()` on them. 

We need to construct a `Softmax` module telling it which dimension we want it to turn into probabilities. In this case, our model is outputting a tensor of shape [1, 2, 112] where the first dimension contains a sequence, the second dimension represents each class, and the final dimension represents all of the individual sequence elements. Since we want probabilities for each class, we tell make a `Softmax` function that turns the second dimension (1) into probabilities:

--CODE

We run our model inside a **context manager** calling `torch.no_grad()` to prevent PyTorch from tracking the computation graph since we won't be calling `backward()` to make it faster and use less memory.

If we subset our output with `[0, 1]` (selecting the only sequence, and the second class) we get our probabilities for being a helix! I'm not great at reading a big list of scientific notation fractions. We can visualize these over our sequence with a lineplot:

--CODE

Here, the blue line represents the true values, sections at y=1 represent helices and y=0 represent not-helices. Our model is doing a pretty good job! The values are quite high for all of our helix amino acids and although there may be a few spikes in non-helix regions, they are in general pretty low!

--CODE

# Working with sequence batches

Big models require big data. To effectively train a model with millions of paramters you need data with millions of obversations. In our case, we only have 110 inputs for a model with 5 million parameters. Talk about overfitting!

Since the models are so big, need so many obversations and our hardware is so much better at operating in parallel than operating faster, it is best if our models can work on multiple input sequences at once. Fortunately all of our modules are designed to do just this. In fact, the reason we needed to `unsqueeze()` our original input at the beginning to make it a different shape was because our models expect **batches** of data. The shape of input tensorts BERT expects is [batch_size, sequence_length, vector_dim]. We can fit as many sequences into a batch as our computer can handle doing backpropogation for without running out of RAM. 

Let's try out four sequences at once. We'll introduce three new, completely different, protein sequences of different length to train as a single batch:

--CODE

We tokenize and form a tensor with these sequences in a very similar way. We don't need to `unsqueeze()` here since the batch dimension is naturally formed when we have more than one sequence.

--CODE

With new sequences, we need new secondary structure to predict. We tensorize these in the same way:

--CODE

And we can use exactly the same training method on this sequence batch as a single sequence. This is the same code as before, but with slightly different variable names:

--CODE

This training progress plot looks a bit more wild, and take a bit longer, but works just as well!

If we extract proabilities in the same way we can see how the predictions for each of our proteins is succesfully learned even though the sequences are of different length and have the helices in different number, lengths, and positions!


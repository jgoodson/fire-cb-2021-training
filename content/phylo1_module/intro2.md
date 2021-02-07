---
title: COVID Phylogenetics Part 1 - MSA and Phylogenetics
date: "2021-02-07"
---

## Phylogenetics

The process of evolution leaves traces in the very genes underlying all life. Mutations happen one or more nucleobases at a time, generally randomly. Through the process of selection, organisms with mutations which are beneficial are more likely to reproduce, organisms with neutral mutations with propagate those at an intermediate rate, and organisms with harmful mutations will be less likely to reproduce. As far as we can tell, time only moves forward, so this process of mutation and selection results in an ever-expanding tree of genetic information, as ancestor genomes split and their different progeny contain distinct mutations in different parts of their genomes. Since we understand how this process works, we can create mathematical models of evolution. With data (genome sequences) we can decide which nucleobases or protein amino acid residues correspond to the same original ancestor position, and back-calculate the path that evolution most likely took to transform one ancestor sequence into all of the available sequences in our dataset. This can be done on ancient time scales, with hundreds or thousands of changes across millions of years, where two sequences may be barely recognizable as having the same ancestor by eye. This can also be done on very short time scales, where we can track individual single nucleobase mutations happening one at a time across a scale of days or weeks. 

## Multiple sequence alignment

Since the process of evolution happens at the individual nucleotide level, we need some way to ensure that our data matches up at the individual nucleotide level. To do so, we line up each of the bases in one sequence with the corresponding bases in another sequence. To infer any amount of evolution, we really need at least four sequences. The process of lining up these individual nucleotide or protein letters is called "alignment" and performing alignment with more than two sequences is known as "multiple sequence alignment". 

Ultimately, there are a variety of programs written to perform this process, aligning multiple sequences and providing output with each sequence lined with with each letter in each sequence matching up with a letter in every other sequence, to the best of the program's ability to predict. Some popular programs to perform this analysis include Clustal, MAFFT, Muscle, and T-COFFEE. Each has its own strengths, although generally all programs will perform similarly on all but the most challenging alignment tasks.

This process, likely almost everything we do, has an input and an output. The input will look very familiar. Generally, the input to a sequence alignment program are biological sequences in FASTA format which we saw in the first half of the assignment. In this case, you can combine multiple FASTA entries into a single file (a "multi-FASTA" file).

```
>Sequence1
ATCGTAGCGTTAGCGAGTCAGTCGATCGGATCGTAGTCAGG
>Sequence2
ATCGAAGCGCTAGCGCCGTCAGTCGATCGGTTCGTAATCAGG
>Sequence3
AATCGAAGCGCTAGGGCCGTCAGTCCGGTTCGTAATCAGG
```

The output of a multiple sequence alignment program will also be a series of sequences, although these may come in several different formats of varying complexity, including ClustalW, NEXUS, PHYLIP, Stockholm, or FASTA. We will be sticking with the most simple format, FASTA, which we already know about. A FASTA format alignment file will look a lot like any other FASTA file, with one difference. Instead of being only nucleotide or protein characters, an alignment file can contain an extra symbol `-` which represents a "gap" a position where the sequence containing the "gap" does not have a nucleobase or amino acid corresponding to that position in all of the other sequences:

```
>Sequence1
-ATCGTAGCGTTAGCGA-GTCAGTCGATCGGATCGTAGTCAGG
>Sequence2
-ATCGAAGCGCTAGCGCCGTCAGTCGATCGGTTCGTAATCAGG
>Sequence3
AATCGAAGCGCTAGGGCCGTCAGTC---CGGTTCGTAATCAGG
```

In these FASTA format sequences, we can see how, despite being different sequence lengths, they correspond to very similar sequences, with some changes and a few positions present in sequence 2 that are missing in either sequence 1 or 3. Each "column" in these FASTA sequences, letters at the same position, correspond to "homologous" residues that presumably evolved from the same position in the ancestor sequence. Positions missing in one sequence represent positions that were added or lost at some point in the evolution of these sequences. In addition to being of great interest to molecular biologists studying a family of sequences, we can use these columns of letters, along with a model of evolution, to determine what process was most likely to have resulted in this exact set of sequences. For practical reasons, few models of evolution account for the process of addition or subtraction of positions, instead purely focusing on substitutions, changes of a position from at A -> T or C -> G. 

**Q7) Look at the position where three bases in a row are missing from sequence 3. Can you tell if those bases were added to sequences 1 and 2 or lost from sequence 3? If so, which do you think happened, and why?**

### Obtaining test data

For this assignment, we will be using a dataset of 23 SARS-CoV-2 genome sequences. I have chosen and downloaded these from the NCBI Virus website for, for consistency. This file is available at folder at (http://training.fire.tryps.in/asn4_subset.fasta) file. You should move to your ASN4 folder and download this file with `wget` now. You can create a similar file by selecting a subset of the table using the web interface, clicking "Download", selecting "Nucleotide", hitting Next, and choosing "Download Selected Records".

**Q8) Open this file up using your choice of text file viewer (`less`, `nano`, etc). This FASTA file has sequence names corresponding to the accession numbers of the virus genomes, all of which are from the same geographical region. Using the web interface to search for a few of the accessions, what geographical region are these sequences from?**


### Performing an MSA with T-COFFEE

We are going to use a program called T-COFFEE to perform our multiple sequence alignment. In practice, T-COFFEE is a large package that can use a huge variety of methods to perform MSA and more. 

http://www.tcoffee.org/Projects/tcoffee/index.html

T-COFFEE has been pre-installed on compute-1 for you, so you do not need to install anything. T-COFFEE is also available as a web service which you can use online:

http://tcoffee.crg.cat/

Performing an alignment with T-COFFEE can be complicated, as there are many parameters, but performing an alignment can also be as simple as running:

```bash
$ t_coffee -seq [sequence file]
```

We use the `-seq` flag to tell T-COFFEE to look for sequences in the `[sequence file]` paramter. If you run this in your ASN4 folder with the file name of the virus FASTA file you downloaded, you should get quite a bit of output, first, some output describing what T_COFFEE is doing, followed by a large alignment, and finally a summary of the output, that may look something like this:

```
OUTPUT RESULTS
        #### File Type= GUIDE_TREE      Format= newick          Name= asn4_subset.dnd
        #### File Type= MSA             Format= aln             Name= asn4_subset.aln
        #### File Type= MSA             Format= html            Name= asn4_subset.html

# Command Line: t_coffee asn4_subset.fasta  [PROGRAM:T-COFFEE]
# T-COFFEE Memory Usage: Current= 30.267 Mb, Max= 32.478 Mb
# Results Produced with T-COFFEE Version_13.41.15.6eaf8df (2020-03-31 17:38:31 - Revision 8874b4a - Build 480)
# T-COFFEE is available from http://www.tcoffee.org
# Register on: https://groups.google.com/group/tcoffee/
```

We have three output files, a "guide tree" in `asn4_subset.dnd`, and MSA (alignment) files in `asn4_subset.aln` and `asn4_subset.html`. The HTML file is a formated web page that I encourage you to download to your own computer and open in your browser. The other appears to be an `.aln` file. This is the computer-readable alignment output we want.

**Q9) Open this `.aln` file up using your choice of text file viewer (`less`, `nano`, etc). Is this a FASTA format file? If not, can you tell what file format this is?**

It turns out T-COFFEE doesn't default to creating the FASTA alignment file we want. Fortunately, T-COFFEE is flexible and has an option to let us specify what output we would like. You can find this feature and many more in the T-COFFEE documentation:

http://www.tcoffee.org/Projects/tcoffee/documentation/index.html#document-tcoffee_quickstart

```bash
$ t_coffee -seq [sequence file] -output=fasta_aln
```

Again, you will see essentially the same output, except now you get these results:

```
OUTPUT RESULTS
        #### File Type= GUIDE_TREE      Format= newick          Name= asn4_subset.dnd
        #### File Type= MSA             Format= fasta_aln       Name= asn4_subset.fasta_aln
```

Take a look at the `asn4_subset.fasta_aln` file and ensure this looks like you expect.

### Performing an MSA with MAFFT

You may have noticed that even with only 23 sequences, T-COFFEE took a few seconds to compute the MSA. These types of algorithms do not scale well, a program that takes 5 seconds for twelve sequence may take minutes for 100 sequences, hours for thousands, and many days for ten thousand. In some situations, we would like to perform analyses on much larger sets of sequences, and (basic) T-COFFEE is not suitable. There are a huge variety of programs which can perform multiple sequence alignments with a wide range of speeds and accuracy. One flexible, high-performing tool is called MAFFT. 

https://mafft.cbrc.jp/alignment/software/

Again, MAFFT has been pre-installed for you. MAFFT is capable of aligning thousands of sequences very quickly with reasonable accuracy. Additionally, it has recently been updated with options targetting the needs of SARS-CoV-2 work, quickly aligning many long, but very similar, sequences.

MAFFT is even simpler to run than T-COFFEE. You can simply run `mafft` with the FASTA filename as the only argument. Unlikely T-COFFEE, which outputs the alignment and other data directly to files, MAFFT outputs the alignment to standard output, so we need to redirect the output:

```bash
$ mafft asn4_subset.fasta > asn4_subset.aln
```

The MAFFT website has a [special page describing options for aligning closely-related viral genomes](https://mafft.cbrc.jp/alignment/software/closelyrelatedviralgenomes.html). Our version of MAFFT is new enough for these commands. Even though we are doing 23 sequences in this analysis, this version of MAFFT could scale to tens of thousands of viruses for thorough analyses! These methods require two input files, one containing your sequences of interest, and another containing a "reference genome" to which all the others will be compared. Fortunately for us, we have a great reference genome! If you completed the first half of this module, you should already have a `NC_045512.fasta` file available.

If you take a look at the "Command" section at the bottom of the page, they provide a variety of different commands for slightly different alignments. As of the writing of this module, these include:

A basic command to align sequqences in a `[othersequences]` FASTA file to a single FASTA sequence in `[referencesequence]` and save the output in FASTA format to `[output]`:
```bash
$ mafft --6merpair --addfragments [othersequences] [referencesequence] > [output]
```

A variant of the above that only outputs "columns" or characters in the alignment corresponding to the reference genome. This is helpful because it makes sure the numbering of characters in our output file is identical to the reference genome and annoation.
```bash
$ mafft --6merpair --keeplength --addfragments [othersequences] [referencesequence] > [output]
```

A version which adds the `--maxambiguous` option to remove "poor" sequences with lots of ambiguity (lots of N characters):
```bash
$ mafft --6merpair --maxambiguous 0.05 --addfragments [othersequences] [referencesequence] > [output]
```

And finally a version which shows that it can be run "in parallel" to take advantage of hardware with more CPUs:
```bash
$ mafft --6merpair --thread -1 --addfragments [othersequences] [referencesequence] > [output]
```

**Q9) What command would you use to align our 23 sequences to our reference genome, keeping only the characters in the reference genome, using parallel alignment? Please run this and ensure your output looks as expected. It should contain 24 aligned FASTA sequences. I suggest naming this file `asn4_subset_ref.aln`. We will use this for subsequent steps.**

## Tree building

As we mentioned before, the (simplified) process of evolution can be thought of as a branching tree, where a single ancestor sequence gains mutations, reproduces, and different lineages contain all the distinct mutations of their predecessors. Of course, there is nothing preventing a position that has changed once from changing again, or even reverting to its ancestor's sequence. Because of these issues and other complicating factors (such as missing or insufficient data), determining the exact process that generated a set of sequences is usually not possible. The best we can do is determine a model of evolution, the paths that evolution took to transform a hypothetical ancestor sequence to our sequences, that fits "the best". What "the best" means can be defined in a few ways. It could mean the simplest route, the "most parsimonious" route, which took the fewest mutations to generate our sequences. On the other hand, not all mutations are equally likely, so taking into account a model of evolution which knows the probability of each mutation, we can calculate the likelihood that a particular evolutionary path generated our sequences, the "maximum likelihood" model. Each of these methods has its benefits, although for our purposes we will likely stick with "maximum likelihood" methods.

This process of determining an evolutionary model can be called different things, like phylogenetic tree reconstruction or tree-building. Like our other steps, this process has an input and an output. At the simplest level, all phylogenetic tree reconstruction programs take a multiple sequence alignment as input, and can generally handle FASTA alignments. The program will then output a representation of a tree. These generally come in one of two formats, Newick or NEXUS format. NEXUS is a more complicated format which is almost a miniature scripting language and can incorporate sequence alignments and analysis steps. Newick format is simpler and represents single trees as a (sometimes very long) line of nested parentheses which can be parsed into a tree. 

![Unrooted newick format](/images/unrooted_newick.png)

Although nothing more than parentheses and commas is truly required for Newick format, Newick trees often have additional data. Names of individual nodes or leaves in the tree can be provided before the colon, and the distance that this node is from its parent can be represented as a number after the colon. Additionally, some trees may contain a third number, representing the "confidence" or "bootstrap" score a particular split has, a kind of error bar illustrating the confidence that that particular section of the tree is correct.

These computer-readable representations are not at all convenient for our brains to parse, but computers are capable of generating images with a more human-readable interpretation of the data:

![Tree Representation](/images/newickTest.png)

Each non-leaf node in a tree represents the relationship between an ancestor sequence and two or more child sequnces which diverged. In reality there is a single true ancestor sequence which should be at the "root" of the tree. Unforunately, without more information, tree reconstruction algorithms don't know which direction any particular mutation went. An A -> G mutation is just as possible as the reverse G -> A mutation. For this reason, the programs generally output an "unrooted tree", where each internal node has three or more connections, and it is unclear where the true ancestor lies. If we have reason to believe a certain group was the most distant ancestor, we can create a "rooted" tree:

![Unrooted newick format](/images/rooted_newick.png)

Instead of having three or more children, the "root node" will only have two and may have a distance defined for it. 

![Tree Representation](/images/rooted_tree.png)

We can use these trees to interpret how this evolutionary reconstruction informs our understanding of how these sequences evolved and the relationships between them.

### Tree reconstruction with FastTree

There are many tools available to reconstruct phylogenetic trees. Similarly to MSA programs, these will largely have similar results on less-challenging datasets. Tree reconstruction, however, is perhaps an even more difficult problem than multiple sequence alignment, and for challenging datasets careful choice of program, evolutionary model, and parameters is necesssary for good results. Expertise in these considerations is not something we will try to gain in this assignment. We will be using a simple, efficient, and reasonably accurate tree reconstruction program called FastTree. FastTree uses FASTA alignments as input and Newick trees as output with incredibly simple syntax, so we can work quickly:

```bash
$ fasttree -nt asn4_subset_ref.aln > asn4_subset_ref.nwk
```

FastTree works on the standard Unix syntax, and sends the output Newick tree file to standard output, so we redirect the output to our file. The only option we need to specify is `-nt` since by default FastTree assumes the alignment is protein sequences. Take a look at this `asn4_subset_ref.nwk` file however you wish. You should notice it has both the species names as well as some numbers. Some numbers are found next to the name, like `MW263335.1:0.000292622` and represent the branch length separating that node from its parent. This number is a representation of "how much evolution" happened to generate this sequence from its immediate ancestor. You may see other numbers, found after some parentheses, as in `(MT106054.1:0.000162554,MW190811.1:0.001009395)0.884:0.000065021)0.848` (the `0.884` and `0.848`). These are the support values, in a range from 0 to 1, with 1 representing absolute confidence, with numbers above 0.5 being generally reliable.

FastTree is a sort of "quick and dirty" method of alignment, without many options or the highest degree of accuracy, but it is often good for simple problems or exploratory work, and is as the name implies, quite fast. For more in-depth approaches we will later learn about other tools including IQ-TREE2. 

**Q10) Identify the "support values" for the tree in the Newick file. How confident, on average, would you say the program is about this tree? What about the specific values makes you say that?**

## Tree Visualization with iTOL

There are many good options for *rendering* Newick trees as visual trees like you've seen in the images before. These come in a variety of forms, including downloaded GUI tools, command-line tools, libraries for scripting languages like Python or R, or web interfaces. I think I've subjected you to enough command-line at this point and it is far too soon to learn Python or R. Instead, we will be using the excellent website [Interactive Tree of Life or iTOL](https://itol.embl.de/) to visualize our tree.

To work with our tree, you should click on "Upload" at the top of the page. You do not need to make an account to use iTOL although it will let you save trees. You can either download your Newick file using Cyberduck, RStudio Server, or other SFTP program, or you may copy the Newick tree text directly into the "Tree text" box on the upload page. In either case, upload your tree!

You should be presented with a page that looks a lot like this (but with some differences from later tweaks I made to this assignment):

![Tree Representation](/images/vir_tree.png)

This tree represents a likely way that these viruses evolved from a common ancestor at the beginning of the pandemic! We probably want some additional information to make use of this. I've prepared a few data files you can use. The first of these is simply the CSV metadata file from the NCBI table: (http://training.fire.tryps.in/asn4_subset.fasta). You can download this and look at it either on your own computer or on `compute-1`.

By default, all tree reconstruction algorithms output "unrooted trees" since you require additional information or assumptions to decide where the root, or original common ancestor of the sequences, is in a tree. If you take a look at the menu at the top right, the first option is "Display Mode". Click "Unrooted" to have iTOL draw the tree in a manner that does not assume a specific common ancestor. 

**Q11) Where does the reference genome fit in the overall shape of this unrooted tree? (You may want to increase the size of the "Branch lines" and "Dashed lines" to better view the structure of the tree, depending on your browser)**

We do have some extra information, and can make some assumptions. We included the reference genome from late 2019. We can make *an assumption* that the common ancestor of the virus in the Wuhan patient was likely closer to the common ancestor than all the Texas samples from at least several months later. You probably want to return the "Display mode" to "Normal". Click on the reference virus in the tree, go to "Tree Structure" and choose "Reroot the tree here". 

At this point you could start to manually match up the information from the CSV file with the sequences on the tree, but that is painful and a lot of work. Most tree visualization tools let you add data or annoations to the trees. You can add this manually by going to the "Datasets" tab, hitting "Create a dataset" and entering data manually. To save time you can also create text files containing the annotation and drag-and-drop them onto the iTOL window and have them automatically loaded! I've created one of these for you that will replace the text labels with the accessions with the date the sample was isolated (http://training.fire.tryps.in/date_dataset.txt). You will need to download this *to your computer* and then drag the file on to your tree in iTOL. I also recommend you open up the text file and look at it. The format is very similar to a normal CSV file with some extra information to tell iTOL how to use it in the drawing. There are [many options for annotating trees in iTOL](https://itol.embl.de/help.cgi#annot).

We now have a customized, rooted, and annotated tree! There are many, many possibilities for drawing and annotating trees depending on our biological questions and objectives.

**Q12) Look at the samples that connect near the base of the tree closest to the reference. Is there anything in common with these samples? What about the rest of the tree?**

## Identifying mutations

We have one final part of this module. I promised that we could use MSA and phylogenetics to identify potentially-important mutations! There are many ways we could go about looking through these alignment files for differences, but we will start with looking at previously-identified important mutations. We will use one of the mutations discussed in [this news article](https://www.cnbc.com/2021/01/12/covid-mutations-all-the-major-strains-we-know-about.html) the "South Africa variant" or "N501Y.V2" mutant. This is a mutation in the spike protein identified in a rapidly-spreading strain of the virus in South Africa. The N501Y part is actually a common method of explicitly describing what the mutation is. In this case, this is a mutation that results in the 501st amino in the spike protein changing from an asparagine (N) to a tyrosine (Y). Since each amino acid is coded for by a "codon" of three DNA bases, we know that this mutation is in one or more of the three nucleotides in positions 1501-1503 of the spike protein coding sequence. Since we found out in the first half of this assignment that the spike protein ranges from 21563 to 25384, we know that the mutation is is positions 21563+1501-1 to 21563+15013-1 or 23,063-23,065. We can identify this codon in each of our samples and find out which, if any, have this variant!

*Side note: we have to substract one from the positions because the GFF3 file started counting from 1, and we don't want to add another 1-start or we will end up off by one position, too far into our sequence! This is actually why there is a big advantage to 0-based indexing in other formats or languages, you do not need this offset as frequently.*

There are a variety of ways that we could tackle this. There is a way to do this with only basic Unix tools, but it involves an insane `awk` command. You don't need to know or understand this:

```bash
$ awk '/^[>;]/ { if (seq) { print seq }; seq=""; print } /^[^>;]/ { seq = seq $0 } END { print seq }' asn4_subset_ref.aln > asn4_subset_ref_oneline.aln
```

We can also use a nice [sequence file toolkit](https://github.com/lh3/seqtk) called `seqtk` to do this same task:

```bash
$ seqtk seq -l 0 asn4_subset_ref.aln > asn4_subset_ref_oneline.aln
```

You can use `nano` or `less -S` to take a look at this file if you like. We can now use `cut` to pull out only specific characters:

```bash
$ cut -c 23063-23065 asn4_subset_ref_oneline.aln
```

You should see that the majority of the sequences have the sequence "AAT, which indeed codes for an asparagine amino acid. 

**Q13) Which, if any, sequence code for something other than an asparagine? What amino acid(s) are coded for instead? Could this be the "South Africa variant"? (You can use a variety of methods to match up the codons to sequences. You might simply count lines and match them up to the original file. You might use `grep -n` to output line numbers, or a variety of other methods I will let you think up!)**

## Next steps

This concludes the technical component of module 2, COVID Phylogenetics. You should answer each of the 13 questions in a text document and upload it as a doc, docx, or pdf file to Canvas for ASN4b. We will continue this module with our [Module 2 deliverable](https://umd.instructure.com/courses/1299512/assignments/5492680). In the deliverable, I will ask your team to perform a similar, slightly longer, analysis on your own selection of data. Good job!


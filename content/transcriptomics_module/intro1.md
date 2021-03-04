---
title: Transcriptomics Part 1 - Sequence Reads and Transcript Counting
date: "2021-02-24"
---

*Note: This assignment has a number of associated questions you'll find as you go through this that need to be submitted on ELMS. Some of these ask you to explain or guess why certain things may be the way that they are. I am not grading on correctness here, rather I am grading based on whether you have completed the assignment and put some thought into the answers. Feel free to discuss these with your group or with me in lab. We will likely go over some of the more important material during class as well.

## Submission

This assignment will be linked on ELMS and there should be a submission form for ASN6b. You should submit this assignment individually. Feel free to work with and discuss the process and questions with teammates, other classmates, or peer mentors.

## Understanding our reference genome

## Module split - CLI/R
The first half of this module will re-introduce concepts used in FIRE-CB intro and phylogenetics module. It will use the same sort of shell commands and will go over these from scratch. Feel free to skim these parts if you are comfortable with the CLI, otherwise this should help reinforce the most useful concepts.

*If you are still struggling with using the CLI and have not already, I strongly encourage you to work through the first three chapters of the DataCamp Introduction To Shell course, available at https://www.datacamp.com/courses/introduction-to-shell-for-data-science *

The second part of the module will introduce you to the R programming language very frequently used in bioinformatics, statistics, and other analytical fields. Although you will not be graded on completion of the DataCamp, I again *strongly* encourage completion of the [Introduction to R DataCamp course](https://learn.datacamp.com/courses/free-introduction-to-r) before or along the second half of this module. 


## Reference genome sequences

To begin, we want to get more familiar with the genome and transcriptome we will be studying initially. This will have similar or identical files to those for the novel coronavirus genomes we looked at in the COVID Phylogenetics module, but will be much bigger! In our case, this main genome is the human reference genome. We will be using the most recent version, version 38 from NCBI Ensembl (GRCh38). We will be interacting with the data in a few ways.

- Directly on the raw sequence data at the whole-genome, chromosome, or individual transcript levels
- Using annotated versions of the genomic data where genes, regulatory elements, or other features are listed by location
- With a web-based interacting database allowing us to search and explore a wide range of database resources from one location

To save some time and space during these steps, you'll be using only one chromosome at a time for this exercise, chromosome 22.

## Obtaining the reference genome

The web-based database for the genome assembly is available at the Ensembl website (https://useast.ensembl.org/Homo_sapiens/Info/Index). Another resource for viewing this information is available on the UCSC website and GRCh38/hg38 (https://genome.ucsc.edu/cgi-bin/hgGateway).

The most current human genome sequences are available on the EMBL-EBI FTP (ftp://ftp.ensembl.org/pub/release-86/fasta/homo_sapiens/dna/). These are compressed FASTA files containing raw assembled genome sequence. There are three variants of the files, one that is labeled "dna" and contains the full sequence. The other two are labeled "dna_rm" and "dna_sm". These are the same sequence, but with some repetitive or duplicated elements removed or "masked" out. We will be using the main "dna" files.

First, we should make a directory to do our work for this assignment. You can name this whatever you like or put it wherever you like.

```bash

cd ~
mkdir ASN6b
cd ASN6b

```

We can now download the sequence for chromosome 22 directly from the EMBL-EBI FTP.

```bash

wget ftp://ftp.ensembl.org/pub/release-86/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.chromosome.22.fa.gz
ls -lh

```

Since this file is compressed, we won't be able to work with it directly. The `.gz` suffix indicates that it is a "gzip" compressed file. We can decompress this file with the command `gzip -d [filename]`. 

Note: Whenever I give you a command with an element in `[square brackets]` that is just a placeholder. You should replace everything, including the brackets, with the text you need (in this case the filename of the file you just downloaded).

**Q1) What does this do to the file and file name? (Check with `ls -lh` before and after)**

Take a look inside the chr22 sequence file to look at the general format of the FASTA files:

```bash

head Homo_sapiens.GRCh38.dna.chromosome.22.fa

```

The beginning of our sequence file may look a little funny. Use the line count you got from the `wc` command to take a look in the middle of the file. To easily pull out some lines in the middle, you can use a combination of the `head` and `tail` commands to get the front of the file up to a certain point, and then the end of that section. Aim for a number of lines roughly halfway through the file.

The `|` symbol is a special character that takes the output from one command, and sends it as input to the second command. In this case, instead of printing 425,000 lines of DNA to the screen, it sends those to the `tail` command, which instead will print the last 10 lines of its input.

```bash

head -n 425000 [filename] | tail

```

**Q2) Do the beginning and middle of the file look similar? Why might one part be different than another? (Speculation is good here, I'm not judging based on correctness)**

### The purpose of the reference genome files

The FASTA reference genome sequence is essential for determining where any particular DNA/RNA sequence in our sequencing data derived from. Read alignment software like TopHat, BWA, or HISAT2 will require these FASTA files to match the short DNA sequence fragments to. After we know what part of the genome a particular fragment comes from, we can infer which transcripts this fragment may have been a part of and in aggregate how many of each transcript there were in the original sample.

## Reference transcriptome

The reference genome is a great resource and has every bit of genome information we know about at this point, but it represents the entire physical existence of the DNA chromosomes. We care about how that information gets transcribed into RNA, and that process involves selecting only certain bits of DNA, transcribing them into RNA, and then cutting and pasting bits of that RNA back together to generate the final transcript. The information that we need to predict how this happens is present in some annotation we will look at next, but the transcript sequences themselves are also available for us. These can be found on the same Ensembl FTP as the genome sequences in a different folder (ftp://ftp.ensembl.org/pub/release-86/fasta/homo_sapiens/cdna/). 

These are labeled as cDNA, as opposed to RNA or transcripts. Since modern sequencing methods require DNA, to determine the sequence of RNA transcripts, a biology trick is necessary to "reverse transcribe" RNA into DNA. Since this generates a piece of DNA complementary to the RNA strand, this is known as "complementary DNA" or "cDNA". There are two types of sequence files available one labeled "abinitio" and one labeled "all". The *ab initio* sequences are a limited set of sequences predicted using simple models directly from the genome file. The *all* sequence files contain several times more transcripts, types of transcripts, and variant transcripts (isoforms) and represent all of the known transcripts compiled from experimental databases. 

Let's download each version:

```bash

wget ftp://ftp.ensembl.org/pub/release-86/fasta/homo_sapiens/cdna/Homo_sapiens.GRCh38.cdna.abinitio.fa.gz
wget ftp://ftp.ensembl.org/pub/release-86/fasta/homo_sapiens/cdna/Homo_sapiens.GRCh38.cdna.all.fa.gz
gzip -d Homo_sapiens.GRCh38.cdna.abinitio.fa.gz
gzip -d Homo_sapiens.GRCh38.cdna.all.fa.gz

```

Since the FASTA format begins each sequence with a special line and follows with any number of lines of sequence, multiple sequences may be included in a single file. This is an example sequence file, the names and sequence will be different.

```

>Sequence1
CGGCATTATCGGAGCTAGCTAGCTGACTG
CGATGAGCATTACGGTA
>Sequence2
GCTAGCGATGCGGCGATTAGCGGGGAGAG
ATCGATGGGACGATGTATGCGTATG

```

The sequence name line always starts with the `>` character.

**Q3) How many transcripts are in each version of the cDNA sequence files? (Hint: if you use the `>` symbol in a command line and you want to mean it is a text character, you should put it in quote `">"`, otherwise it will be used as a special character like the `|`.)**

### The purpose of the reference transcript files

Not all methods for transcriptome analysis use direct read alignment to genomes. In recent years, tools such as Sailfish, Kallisto, or Salmon have become available to rapidly and directly estimate the original number of transcripts directly from the individual DNA fragment sequences. These approaches use lists of individual transcript sequences instead of the original genome sequence. Although these methods do not give you full alignments useful for things like variant calling or other techniques and cannot identify any new transcripts, they can be invaluable for efficiently quantifying the number of each transcript for expression analysis. Since this is the main focus of this module as well as the pharmacogenomics module, we will likely lean heavily on these transcript-focused approaches.

## Reference genome annotation

With only the raw DNA sequence, or even the raw cDNA sequences, there isn't a lot we can do. I certainly can't figure out much biologically meaningful information manually from one cDNA sequence, much less tens of thousands. Fortunately, since we began sequencing and studying the human genome, thousands of researchers have spent decades investigating every bit of the human genome. Since this is science, the community has published, collected, and organized this information in a variety of ways to let use associate bits of the human genome with relevant biological information. In general, this process is called *annotation*. 

There are several common file formats for containing gene-level annotation of genomes, but perhaps the most common is GTF/GFF. Both file types are very similar, with some subtle differences (https://www.ncbi.nlm.nih.gov/genbank/genomes_gff/). Both formats are simple text files containing one feature annotation per line. Lines that start with `#` are "comment" lines and don't represent features but do include information that might be useful for orienting yourself with the file. Each normal line contains nine columns separated by tabs. The first eight columns are simple names, numbers, or symbols representing the name, type, and location of the feature. The final column can be much more complicated and contains a list of attributes in name=value pairs. The details of the GFF3 format may be found at https://github.com/The-Sequence-Ontology/Specifications/blob/master/gff3.md

Since these features are referenced to specific numeric locations in a sequence file, any annotations much match up to a specific reference genome sequence. The Ensembl FTP has files available both for individual chromosomes as well as the entire chromosome or transcript cDNA files. 

```bash

wget ftp://ftp.ensembl.org/pub/release-86/gff3/homo_sapiens/Homo_sapiens.GRCh38.86.chromosome.22.gff3.gz
gzip -d Homo_sapiens.GRCh38.86.chromosome.22.gff3.gz
head -n 20 Homo_sapiens.GRCh38.86.chromosome.22.gff3

```

**Q4) How many coding sequences ("CDS" annotations) are present on chromsome 22?**

###  The purpose of the reference sequence annotation

When running alignment-based approaches, the exon and transcript level annotations are essential for determining what RNA/cDNA sequences might exist. Individual strings of DNA letters may show up in our RNA sequencing data that do not exist together in the original genome. These might be due to events like splicing which fuse two distant sequences together, or from non-templated addition like in the poly-A tails at the end of mRNAs.  Aligners like TopHat or HISAT2 will use these annotations to properly map these types of reads.

Beyond the process of alignment, these annotation files contain the information that lets us know what gene or gene variant is associated with any particular transcript. Knowing what sequence is what gene is essential for interpreting the results, understanding what changes and what doesn't change and therefore what is happening in the biology of our samples. This is the case whether we choose to align directly to the genome or use transcriptome-level quantification tools.

##Obtaining transcriptome quantification data

So far we have taken a look specifically at the human reference information. None of this is specific to the experiments we want to analyze. Much like the reference, our data is present in some sequence databases. In contrast to the reference genome though, our data is in a more specialized database intended to provide a warehouse for large amounts of publicly-accessible high-throughput sequence data called the Short Read Archive (SRA). The SRA is hosted by the NCBI, part of the National Institute of Health in Bethesda, Maryland. It is part of an interconnected series of databases which include a variety of annotation about about experimental data. 

### Exploring the data in the NCBI databases

Some of the relevant NCBI databases for obtaining and understanding our data will be `BioProject`, `BioSample`, `SRA`, and `PubMed`. The first of these, `BioProject`, (https://www.ncbi.nlm.nih.gov/bioproject/) is designed to contain, categorize, and describe whole experimental projects. This database will contain links not only to the raw data hosted in databases like `SRA` or `GEO`, but also to any publications that may be associated with this data as well as metadata associated with the raw data itself. 

Some of this metadata is present in the `BioSample` database. This is intended to be a higher-level description of the raw data, each entry is, much like the name, a biological sample that some data derived from. This could be a particular batch of cells grown in a test tube, an environmental sample of water, a biopsy of human tissue, or essentially any other biological unit of physical *stuff* we might sample to generate data. The `BioSample` entries themselves may then be associated with raw data that was derived from that particular biological sample. The quality of this annotation may vary from experiment to experiment because it is up to the individual scientist submitting this to the database to decide which information to include in the submission to the database.

The `BioProject` entries themselves often contain only a brief summary of the experimental goals and data content. In many cases, to really understand what all of the samples represent and how they were generated, you may need to read the associated publications to get enough information. 

*We will be working with data that largely resides in one `BioProject` entry. The accession number for these datasets has the `BioProject` accession PRJNA699856. Searching for this in the link provided above should bring up the summary page for the project. Clicking on the number of SRA experiments brings you to a result list in the SRA database. A link at the top of the page should bring you to the SRA Run Selector which lets you interact and download a table containing more information about the data itself.*
 
![Run selector](/images/SRASelector.png)
 
**Q5) How many RNA-seq datasets are present in this project? How many of these correspond to samples from healthy patients and how many to patients who retested positive? What other potentially import biological variables can you find in the annotation for these experiments?**
 
### Downloading raw data
 
There are several ways to download the raw sequence data from the SRA database. These can be directly downloaded from the website, from several cloud services, or through command line tools called `sra-tools`. Because together these datasets take up almost an entire terabyte even compressed, these have already been downloaded and are present in a folder on compute-1 at `/shared/data/` in the `transcriptomics` folders respectively. If you do need to download any additional datasets, instructions for using the `fasterq-dump` program to directly download SRA datasets is found at https://github.com/ncbi/sra-tools/wiki/HowTo:-fasterq-dump
 
You can list the downloaded datasets:
 
```bash
 
ls -lh /shared/data/transcriptomics
 
```
 
Since these are very large files, we would like to keep them compressed as much as possible. Forunately, through the magic of piping, in many cases it is not necessary to run gzip before you run additional commands, the `gzip` program can be chained just like other unix programs. Adding the `-c` flag to the gzip command forces it to read input or send output to the console, allowing us to either directly print or pipe the data to other programs. Each dataset consists of two files, ending in either `_1.fastq.gz` or `_2.fastq.gz`. This is a consequence of the method of sequencing our samples used, which generates sequence from both ends of each DNA fragment, in a process called "paired-end sequencing". Each set of four lines in each file represent a single read. 

```bash

gzip -dc /shared/data/transcriptomics/SRR13639979_1.fastq.gz | head
gzip -dc /shared/data/transcriptomics/SRR13639979_2.fastq.gz | head

```

**Q6) Given the output of the previous command, how can you tell which read from file 1 corresponds to its paired read in file 2? (Hint: look at what is similar between the first lines of the FASTQ files)**

### Initial quality control

There are several programs designed to generally analyze the output from high-throughput sequencing to screen for a variety of common problems or contamination issues that arise. Perhaps the most popular is a program called FastQC (https://www.bioinformatics.babraham.ac.uk/projects/fastqc/). You can use FastQC in two modes. One mode involves running FastQC like a normal GUI program. Download it onto your computer, unzip, and run the `run_fastqc.bat` file. You can then open up `fastq.gz` files you have downloaded to your computer and analyze them directly. The other mode runs via the command line and instead generates HTML output that you can download and view in a web browser. For the final part of the assignment, you have a choice to follow either method. Both will ultimately involve transferring files from the server to your own computer with WinSCP, Fetch, or other SFTP program.

#### Run FastQC graphically on your own computer

If you choose to run FastQC on your own computer, ensure that you have at least 15 GB of free space on your hard drive first. This method is also only advisable if you are on a fast on-campus internet connection. Finally, you will need Java installed on your computer. If none of these apply, please don't use this method and skip to method 2. Download FastQC from the link above, choosing either "FastQC v0.11.8 (Win/Linux zip file)" if you run Windows or "FastQC v0.11.8 (Mac DMG image)" if you have a Mac. Extract the file you downloaded and run FastQC following the instructions for either version.

Next, you will pick one of the SRA datasets from `transcriptomics` folder. **Do not use the SRR13639979 dataset in the examples.** Connect to the server with your SFTP program of choice and navigate to `/shared/data/transcriptomics`. Download one dataset to your computer (both the `_1.fastq.gz` and `_2.fastq.gz` files). Finally, in the FastQC program go to the open file menu, navigate to, and select the two `.fastq.gz` files you downloaded from the server. This will take a few minutes to analyze both files and should show you the progress as it works.

#### Run FastQC remotely on compute-1 and download the results
 
As an alternative to running FastQC on your computer and directly viewing the results, you can use the FastQC program installed on the compute-1 server. Pick one of the SRA datasets from the `transcriptomics` folder. **Do not use the SRR13639979 dataset in the examples.** Next, you should run the `fastqc` program and give it the full path to the files you chose, as well as the location you want to store the output. On the command line the `.` character as a file represents the current directory you are in. Either of the following commands will analyze both files at the same time. This will take a few minutes to analyze both files and should show you the progress as it works.
 
```bash

fastqc /shared/data/transcriptomics/[dataset]_1.fastq.gz /shared/data/transcriptomics/[dataset]_2.fastq.gz --outdir=. 
fastqc /shared/data/transcriptomics/[dataset]_*.fastq.gz --outdir=. 
 
```

After this completes, running `ls` in your current (output) directory should show several additional files. There should be two additional `.html` files and two `.zip` files. You will need to download these to your own computer to view them. Connect to the server with your SFTP program of choice (Cyberduck, RStudio, etc) and navigate to the folder your are currently in. If you followed this exactly this will probably be `ASN6b` in your home directory. Download the `.html` files to a folder on your computer, and open these in your preferred web browser.

### In either case...

Once you have the results for both files, take a look through the different results sections. For the following questions you may want to refer to this guide from Michigan State University for help interpreting the results: https://rtsf.natsci.msu.edu/genomics/tech-notes/fastqc-tutorial-and-faq/

**Q7) Compare the html files results from both of the read 1 and read 2 files you analyzed. Do you notice any differences between them? How many reads were present in the dataset you chose?**

**Q8) Did any of the FastQC analysis modules flag potential problems? For each problem, refer to the MSU guide. Do you think we should worry about these problems? If not, why not? If so, what might we do to address the problem?**


# 2-ii. Aligning our RNA-Seq reads

It is finally time to put our dataset together with the human genomes we downloaded! Remember, the idea behind this RNA-seq process is to measure how much of each transcript, each RNA is present in our sample cells. When a gene is transcribed from the genome into RNA, the resulting RNA should have exactly the same sequence as the DNA is was copied from (with T replaced with U). The RNA-seq process converts this RNA back into DNA before sequenncing. The result: the individual chunks of sequence we get out should be nearly identical to some chunk of the human genome, accounting for differences between the individual person and the reference genomes and any mistakes made by the sequencing process. The sequencing process generates DNA reads in numbers proportional to the amount of each RNA that they were derived from. Now that we have millions of these fragments, we want to figure out which part of the genome, which possible RNA transcripts these derived from. If we count up how many DNA fragments came from each possible RNA, we'll have a measure of how many RNA there were physically there in the first place!

To find out exactly where in the genome a piece of DNA came from, we need to compare this to the genome, and find a position in the genome with the same (or very similar) sequence to the DNA read itself. We could hypothetically compare each read to every position in the genome. There are approximately 3 billion bases in the human genome. Each of our reads is 100 bases long, so to check if one read is the same as one position we need to compare 100 letters. Since our samples have approximately 100 million reads, we would need to do 3 billion \* 100 million \* 100 comparisons. Even if we have a computer that can perform 40 billion comparisons per second, which is pretty reasonable in this case, it would take over 200 years to check one sample this way. Even this underestimates how long this process might take, because we would like to take into account possible sequencing mistakes.

## Alignment

Fortunately, some very smart computer scientists have come up with algorithms that let us match reads to positions in the genome, lining up a read with its genomic match in a process called "alignment". These operate dramatically faster than the straightforward comparison of every read with every possible position. 

![Read alignment](/images/Read_alignment.png)

![Read alignment2](/images/Read_alignment2.jpg)

You can visualize this process. Each of our reads (one of the red lines) is a short fragment. This sequence read should have the same sequence as a chunk of our genome, probably a part corresponding to a gene or transcript (blue regions). We have a big pool of reads, and by finding their matching position in the genome we know that we had some fraction of our RNA transcribed from that position. Sometimes the reads don't match perfectly in sequence to the genome. This can be because of errors, or because the genome of the organism we sequenced (maybe my macrophages!) don't have exactly the same sequence as the reference genome, generated from a variety of humans that weren't me. As long as the differences are small (like a single base difference represented by the star and green dots), the aligner will just note the mismatch but align the read to the correct position.

In higher organisms, RNA transcripts are frequently not identical to the underlying genomic sequence because of a process called "splicing".

![Splicing](/images/splicing.PNG)

Eukaryotic organisms construct their final mRNA transcripts by initially transcribing a much longer intermediate transcript and essentially cut-and-pasting individual chunks of RNA sequence together into the final form. If we sequence one of these mature mRNA sequences and the sequence happens to cross this "splice point", the sequence won't match up to the genome anymore. The first part of the read may align to one section of the genome and the second part may align thousands of nucleotides away! For this reason, aligning these types of potentially spliced reads is a substantially harder computational problem and uses different, more advanced alignment software.

![Spliced reads](/images/spliced_reads.svg)

We can use special algorithms to search for the best match between our sequences and the reference genome. If that best match is found in a particular gene, we say that that sequence represents a transcript made from that gene. We can do this for all of the millions of sequence reads in our genome and generate a list of how many transcripts were made from each and every gene. This represents our *transcriptome* which we can use in all sorts of cool ways.

## Counting transcripts with Salmon

## Obtaining and indexing the reference genome

Salmon needs as input a list of transcripts to look for matching sequence reads to. We have already downloaded one of these for the human genome earlier in the assignment: `Homo_sapiens.GRCh38.cdna.all.fa.gz`. We decompressed this file so it should be called `Homo_sapiens.GRCh38.cdna.all.fa` now. Part of the magic behind these transcript quantification tools is that they don't simply run through the transcripts one-by-one looking for matches. Instead, they use a computer science construct called a *suffix array* that lets it find matches much more quickly. To do this, it needs to make a set of "index" files storing this information. To save time, we will use a pre-built version of the GRCh38 version genome (hg38) from this page: http://refgenomes.databio.org/

This index is available in `/shared/data/transcriptomics/salmon_hg38/` if you want to look at it.


## How do we know which read corresponds to which feature?

When a gene is transcribed from the genome into RNA, the resulting RNA should have exactly the same sequence as the DNA is was copied from (with T replaced with U). The RNA-seq process converts this RNA back into DNA before sequenncing. The result: the individual chunks of sequence we get out should be nearly identical to some chunk of the human genome, accounting for differences between the individual person and the reference genomes and any mistakes made by the sequencing process. We can use special algorithms to search for the best match between our sequences and the reference genome. If that best match is found in a particular gene, we say that that sequence represents a transcript made from that gene. We can do this for all of the millions of sequence reads in our genome and generate a list of how many transcripts were made from each and every gene. This represents our *transcriptome* which we can use in all sorts of cool ways.

## Running Salmon

To start counting our features, we only need two things. The transcriptome index (discussed above) and the sequence reads that will correspond to them. 

Salmon has been pre-installed for you and is ready to go. We will run it with a command something like this. You will need to substitute in the following:

* The path to the salmon index folder for [index folder]
* The path to the [SRA Accession]_1.fastq.gz for the [fastq read 1]
* The path to the [SRA Accession]_2.fastq.gz for the [fastq read 2]
* A folder name for the output to be stored in, I recommend the SRA accession of the file you use

```bash

salmon quant -i [index folder] -l A -1 [fastq read 1] -2 [fastq read 2] -p 4 --validateMappings -o counts/[output name]

head counts/[output name]/quant.sf
tail counts/[output name]/quant.sf

```

You should construct and run a command to count the transcripts in the SRR13639979 sample. It will output some progress as it runs and will take a few minutes to complete.

**Q9) What command did you run? How many lines are in the out file? Look up how many genes are in the human genome. Does the number of lines match up with this? Should it? (Speculation is good at the end here)**

We can see that Salmon quantification output has five tab-delimited columns: Name, Length, EffectiveLength, TPM, NumReads.

* *Name* is the name/identifier for the transcript
* *Length* is the length, in nucleotides, of that transcript
* *EffectiveLength* is the "effective length", in nucleotides, of that transcript. This is relevant for some statistics
* *TPM* stands for "transcripts per million" and represents the number of counts normalized for many many total sequence reads we have
* *NumReads* The raw number of reads that corresponded to that transcript.

Now that we have this sort of tabular summary of each gene in the genome, with values corresponding to the amount of RNA in each sample, we are ready to begin our statistical analysis! 

In the next section, we will have count tables like this prepared for all of the samples in the experiment so we don't have to have everyone run hours of feature counting. Next, you should work on a DataCamp course [Introduction to R DataCamp course](https://learn.datacamp.com/courses/free-introduction-to-r) to get an introduction to R, a statistical scripting language that will allow us to use some very powerful analysis tools to follow up on these tables, if you have not already.

## Next steps

This first half of our technical training module asked you to become familiar with how to access genome annotation and sequencing data from the NCBI databases , how the sequence and annotation files are formatted, and how to process this data for analysis. In the [second half](/transcriptomics_module/intro2/), we will obtain use R and DESeq2 for differential expression analysis to learn more about what effects occur in peripheral blood immune cells when infected by COVID-19.

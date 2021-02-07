---
title: COVID Phylogenetics Part 1 - Sequence and Annotation Data
date: "2021-02-07"
---

*Note: This assignment has a number of associated questions you'll find as you go through this that need to be submitted on ELMS. Some of these ask you to explain or guess why certain things may be the way that they are. I am not grading on correctness here, rather I am grading based on whether you have completed the assignment and put some thought into the answers. Feel free to discuss these with your group or with me in lab. We will likely go over some of the more important material during class as well.

## Submission

This assignment will be linked on ELMS and there should be a submission form for ASN4 (Training). You should submit this assignment individually. Feel free to work with and discuss the process and questions with teammates, other classmates, or peer mentors.

### Connecting to the command line

Since the datasets we could potentially be using are quite large, with thousands of files, and moreso with some later training modules, we cannot always easily run our analyses on our own computers or on the web. We have a system set up in the cloud with  althe software we will need pre-installed with plenty of storage space that you have already connected to. 

For the majority of the work, we will be connected to the command line interface remotely. We will be using a method called SSH or Secure SHell to do so. If you already have opinions or preferences about what software to use for this, feel free to use whichever method you like. 

At some points, we will also want to be able to transfer files to and from our personal computers and the server. If you are already set up with [Cyberduck](https://umd.instructure.com/courses/1299512/pages/sftp-with-cyberduck), great! You may also use [RStudio Server](https://umd.instructure.com/courses/1299512/pages/rstudio-server) to transfer files to or from `compute-1` if you have experienced issues with Cyberduck. Other good options include WinSCP for Windows and Fetch for macOS.

## 1-ii. Understanding our reference genome

### Introduction to shell usage for bioinformatics

During your first training module you were shown a variety of basic tools and asked to use them to manipulate, view, and edit some text files. This may have started a little abstract, but starting with this module we will start applying these types of tools in earnest, as we add specialized computational biology commands to our repetoire. If you have not already, I strongly recommend using the DataCamp module to practice and gain exposure to a wider variety of useful tools and techniques.

### Reference genome sequences

Since we want to use the wealth of sequenced SARS-CoV-2 genomes to begin looking at how the virus may have mutated over the course of the pandemic, we should begin by becoming familiar with what these look like. We will use the "RefSeq" **Ref**erence **Seq**uence version of the novel coronavirus genome. This is a virus [originally isolated from a patient employed as a worker at a seafood market in Wuhan, China, in December 2019](https://pubmed.ncbi.nlm.nih.gov/32015508/). 

We may be interacting with the data in a few ways.

- Directly on the [raw sequence data](https://www.ncbi.nlm.nih.gov/nuccore/NC_045512.2?report=fasta) at the whole-genome level
- Using [annotated versions of the genomic data](https://www.ncbi.nlm.nih.gov/nuccore/NC_045512) where genes, regulatory elements, or other features are listed by location
- With a [web-based interactable database](https://www.ncbi.nlm.nih.gov/labs/virus/vssi/#/virus?SeqType_s=Nucleotide&VirusLineage_ss=Severe%20acute%20respiratory%20syndrome%20coronavirus%202,%20taxid:2697049) allowing us to search and explore a wide range of database resources from one location

### Obtaining the reference genome

There are (at least) two primary databases with well-organized and available novel coronavirus genomes, one run by [the NCBI](https://www.ncbi.nlm.nih.gov/), a part of the US National Institutes of Health, and [GISAID](https://www.gisaid.org/), an international initiative consisting of non-profits, governments, and companies originally set up to track influenza viruses, now possibly the largest database of novel coronavirus genomes. Unfortunately, data access to the GISAID database is more complex and requires registration and approval, while the NCBI database is freely available. The NCBI database will be largely sufficient for our purposes.

The NCBI has extensive databases for many, many ares of biology ranging from genome sequence ([RefSeq](https://www.ncbi.nlm.nih.gov/refseq/), [GenBank](https://www.ncbi.nlm.nih.gov/genbank/)), to experimental data ([SRA](https://www.ncbi.nlm.nih.gov/sra), [GEO](https://www.ncbi.nlm.nih.gov/geo/), or even scientific papers ([PubMed](https://pubmed.ncbi.nlm.nih.gov/)). NCBI has set up a [special web interface for interacting with the viral genomes in RefSeq and GenBank](https://www.ncbi.nlm.nih.gov/labs/virus/vssi/#/virus?SeqType_s=Nucleotide&VirusLineage_ss=Severe%20acute%20respiratory%20syndrome%20coronavirus%202,%20taxid:2697049). You should click on this final link, which should take you to a table. This table is the source for the genome metadata CSV file you used in module 1. The first genome listed (first row of the column) should have a "RefSeq" note next to the accession number.

**Q1) An "Accession" number is a unique identifier for a particular item allowing you to *access* it from a particular database. An item might have more than one accession number for different databases. What is the RefSeq accession number for the SARS-CoV-2 reference genome? What data was this released to the public?**

First, we should make a directory to do our work for this assignment. You can name this whatever you like or put it wherever you like.

```bash

cd ~
mkdir ASN4
cd ASN4

```

While you could download the genome "FASTA" file from the site and upload it, we can directly download this to our folder:

```bash

wget http://training.fire.tryps.in/NC_045512.fasta.gz
ls -lh

```

The `.gz` suffix indicates that it is a "gzip" compressed file. This is similar to a "zip file" that you may be used to, but only is only a single file. Since this file is compressed, we won't be able to work with it directly. We can decompress this file with the command `gzip -d [filename]`. 

Reminder: Whenever I give you a command with an element in `[square brackets]` that is just a placeholder. You should replace everything, including the brackets, with the text you need (in this case the filename of the file you just downloaded).

**Q2) What does this do to the file and file name? (Check with `ls -lh` and compare the output before and after you decompress the file) You can always delete the file with `rm` and download it again if you need to.**

Take a look inside the reference sequence file to look at the general format of the FASTA files:

```bash

head NC_045512.fasta

```

Then to look at a sort of summary view, use the `wc` command to count the number of lines, "words", and characters (in that order) in the file:

```bash 

wc NC_045512.fasta

```

**Q3) How many lines and characters are there in our sequence file? Take a look at the "Length" column of the NCBI table, telling us the size of the genome. How well does this length match up with what we find from the file with `wc` and why might they be different?**


We can use very powerful `grep` search tool to find specific patterns in a file or input. `grep` works by calling `grep [pattern] [filename]` where `[pattern]` is text that we want to match. `grep` will output only those lines in the file that contain the search pattern we gave it. For instance the following command will find all lines that contain the particular series of DNA "GAATTC":

```bash

grep GAATTC NC_045512.fasta

```

**Q4) How many of each base (A, C, G, T, or N) are present in the reference virus? There are multiple ways to answer this. Hint: using `grep -o [search_text] [filename]` with the `-o` flag outputs every match on a new line instead of entire matching lines. You can combine this with the `wc` command in a similar way to how we just combined `head` and `tail`.**

*Optional question: AQ1)* * **Restriction sites** are DNA elements targeted by special enzymes known as "restriction enzymes" which cut DNA at palindromic sequences. How many EcoRI sites are present in chromosome 22? How did you determine this? (This need to be correct, think carefully about how one big contiguous sequence of chromosome is represented in this FASTA file)*

### The purpose of the reference genome files

The FASTA reference genome sequence is essential for comparing other virus isolates. This reference represents a virus that existed near the beginning of the pandemic, before most of the spread and potential mutations had a chance to happen. It is a "complete sequence" representing the whole viral genome and has "well-annotated" features, letting us find out which of the 29,903 nucleotides represent which genes or protein-coding sequences. If we identify mutants, we probably would want to know where they are and what parts of the virus they might affect in order to guess at what they might do! In order to connect the genome sequence with this extra information, we need that *annotation*.

### Reference Genome Annotation

With only the raw DNA sequence, or even the raw cDNA sequences, there isn't a lot we can do. I certainly can't figure out much biologically meaningful information from raw DNA sequence. Fortunately, since we began sequencing and studying betacoronaviruses (the larger family of viruses the COVID-19 virus is part of), getting a kickstart with the original SARS, thousands of researchers have spent years investigating the various parts of the viruses. Since this is science, the community has published, collected, and organized this information in a variety of ways to let use associate bits of the genome with relevant biological information. In general, this process is called *annotation*. 

There are several common file formats for containing gene-level annotation of genomes, but perhaps the most common is GTF/GFF. Both file types are very similar, with some subtle differences (https://www.ncbi.nlm.nih.gov/genbank/genomes_gff/). Both formats are simple text files containing one feature annotation per line. Lines that start with `#` are "comment" lines and don't represent features but do include information that might be useful for orienting yourself with the file. Each normal line contains nine columns separated by tabs. The first eight columns are simple names, numbers, or symbols representing the name, type, and location of the feature. The final column can be much more complicated and contains a list of attributes in name=value pairs. The details of the GFF3 format may be found at https://github.com/The-Sequence-Ontology/Specifications/blob/master/gff3.md This format is very similar to the CSV file format we have looked at, but with "tabs" instead of commas.

Since these features are referenced to specific numeric locations in a sequence file, any annotations much match up to a specific reference genome sequence. Although you can't download the annotation directly off of the NCBI Virus table, you can get it from the [GenBank page](https://www.ncbi.nlm.nih.gov/nuccore/NC_045512) by clicking "Send To", selecting "Complete Record", "File", and then choosing `GFF3` for Format. I have also uploaded a version for your use.

```bash

wget http://training.fire.tryps.in/NC_045512.gff3.gz
gzip -d NC_045512.gff3.gz
head -n 20 NC_045512.gff3

```

**Q5) The third column of the gff3 files contain the type of feature. How many different types of features are present in this genome annotation? How many coding sequences (labeled `CDS`) are there? How many standard `gene` annotations are there? What could this tell you about the relationship between "genes" and coding sequences? You may need to combine commands from module 1, including `grep`, `wc`, or `cut`.**

#### Exploring annotation graphically

You can access a convenient graphical view of the reference genome. You can find the GenBank page for the reference genome by clicking on the Accession in the table, which should pop up a "Nucleotide Details" window in the table. Clicking on the accession number in this window should take you to the main page for the nucleotide sequence of this virus. The default page is a web page version of a file format named "GenBank". This file format shares its name with the GenBank database and is the primary format used for DNA seequences in that database. This format combines annotation, metadata, and sequence all in one file and is extremely convenient, but requires specialized tools or programs to work with that we will save for much later in this stream!

Once on the GenBank page, there should be two links at the top, immediately under the (long) title of this sequence entry, labeled "FASTA" and "Graphics". The "FASTA" link will take you to a page with the FASTA sequence you looked at earlier. Following the "Graphics" link on the other hand, takes you to the integrated GenBank graphical sequence viewing tool. This is a relatively powerful and convenient tool for exploring sequence files! There is a lot going on, so I recommend you watch my video on the NCBI GenBank viewer.

The top section of the viewer, containing some green rectangles with white arrows, is a high-level overview of the main features in the genome and how they are arranged. Under that is an interface bar with some menu buttons allowing you to run a variety of functions. Under that is a bar showing the "coordinates" or numbering of the DNA bases in the sequence on top of a detailed feature view showing all of the features present in the GFF3 file to scale, where the fit in the almost 30,000 DNA bases of the novel coronavirus genome.

Betacoronaviruses have some unusual genetic features, where "open reading frames" code for multiple proteins in one long sequence and the proteins are later processed into individual units by later steps. In general, green bars represent "genes", red bars represent "protein coding sequences", brown bars represent processed peptides/proteins, and black bars represent other types of features of interest. 

**Q6) The coronavirus "spike protein" (or "S protein") has been implicated in cell entry, immune system evasion, and is the primary target of current vaccines. For perhaps obvious reasons, we will care a lot about the spike protein. Using either the graphical viewer or the GFF3 file, what region of the reference genome is the spike protein coded by? (I would like a range of nucleotide coordinates, for instance the "M protein" is coded by nucleotides from coordinate 26523 to 27191.)**

*Side note: There is an unfortunate conflict between coordinate systems in bioinformatics. If you know much about computer science, you may know about 0-based vs 1-based indexing. There is no consistency between programs or formats. GFF3 uses "1-based indexing" where you start counting from 1 and the end coordinate is the number of the last position. Other formats used "0-based indexing" or "0-based, half-open" indexing. GFF3 and the R programming language (and most humans!) use 1-based indexing, while the BED format and the Python programming language use 0-based indexing. There are good reasons to use both, but it is unfortunate that we often have to switch back and forth. A nice cheat-sheet for thinking about this can be found here: (https://www.biostars.org/p/84686/)*

## Next steps

This first half of our technical training module asked you to become familiar with how to access viral genomes from the NCBI database, how the sequence and annotation files are formatted, and to begin to think about what information is available to use in these genomes. In the [second half](/phylo1_module/intro2/), we will obtain more genomes, compare, and analyze them using phylogenetic techniques to learn more about how this pandemic has progressed.


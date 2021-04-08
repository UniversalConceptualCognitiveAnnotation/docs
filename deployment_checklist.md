Deployment of UCCA Repositories - Checklist
--------------------------------------------

All ucca corpora are kept in https://github.com/UniversalConceptualCognitiveAnnotation.<br/>
All the scripts mentioned below are included in the ucca package: https://github.com/huji-nlp/ucca.
 
When creating a new repository or making any changes to one of the existing repositories, make sure you follow these steps:
 
1) Download the relevant tasks from the UCCApp:<br/>
Having a file with one task ID per line (in this example “task_ids.txt”) , run:

        python uccaapp/download_task.py -f task_ids.txt -o <outdir> --email=X --password=X -l downloaded.log
    
   It will save the XML files to the output directory.<br/>
   Note that for some corpora it is best to use the “external” IDs (e.g STREUSLE/UD for EWT and PTB for WSJ). To do that, add the flag `--by-external-id` when you run the download_task script. Then the XML files will be named accordingly.
   
2) Normalize the downloaded xmls:     

        python scripts/normalize.py <xml_files> -o <outdir>

   The normalized xml files will appear in the output directory.
        
3) For German and English passages, also run:

        python scripts/convert_articles_and_reflexives.py <xml_files> -l [lang] -o <outdir>
        
    Note that you need to replace `[lang]` with the right language symbol (`en`,`de`)

4) Upload the xmls to the relevant repository: clone the relevant repository to your computer, make the changes and push.<br/>
Note that before uploading WSJ passages, you need to replace the tokens with underscores for licensing reasons. To do that run `scripts/insert_tokens.sh` on your local UCCA_English-WSJ repository, where you had placed the changed xmls. 

5) An automatic validation report is generated upon any change made to a repository. Make sure your data passed validation and that there are no errors. Validation reports can be found [here](https://travis-ci.org/github/UniversalConceptualCognitiveAnnotation).

6) Make sure that the details in the repository’s README are updated. If you are creating a readme from scratch, you can use [this template](https://github.com/UniversalConceptualCognitiveAnnotation/docs/blob/master/README_template). 


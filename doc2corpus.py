def tm():

    import sys
    import nltk
    import string

    input_file_name = raw_input("Please enter the input file name: ")
    input_path = raw_input("Please enter the input path: ")
    output_file_name = raw_input("Please enter the output file name: ")
    print '\nPlease note that the above entered filename would be used as',
    print 'a prefix for the entire set of documents to be generated.\n'
    output_path = raw_input("Please enter the output path: ")

    with open (input_path + '\\' + input_file_name + '.txt','r') as f:

        para = []
        data = f.read()
        selected=0
        notselect=0
        sentences = data.split("\n\n")

        print "Total # of paragraphs",len(sentences)

        for x in xrange(len(sentences)):
            cond = sentences[x].endswith(".")
            if cond:
                cnt = sentences[x].count(".")
            else:
                cnt= sentences[x].count(".")+1

            if cnt >5:
                #print "paragraph ",x+1,"is selected"
                selected+=1
                sentences[x] = '@'+sentences[x].lower()
                sentences[x] = sentences[x].translate(string.maketrans("",""),string.digits)
                sentences[x] = sentences[x].translate(string.maketrans("",""),string.punctuation)
                tokens = nltk.word_tokenize(sentences[x])
                lemma  = nltk.WordNetLemmatizer()
                porter = nltk.PorterStemmer()

                afewwords = [lemma.lemmatize(i) for i in tokens]
                afewwords = [porter.stem(i) for i in tokens]

                sentences[x] = ' '.join(afewwords)
                para.append(sentences[x])

                filename = output_path + '\\' + output_file_name + str(selected) + '.txt'
                w = open(filename,'w')
                w.write(''.join(para))
                w.close()
                para = []
            else:
                #print "paragraph ",x+1,"is not selected"
                notselect+=1
            #print "cnt - ", cnt
        #print"\n"

        print "# of paragraphs selected",selected
        print "# of paragraphs not selected",notselect
    f.close()
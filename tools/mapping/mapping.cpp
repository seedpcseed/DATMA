/*---------------------------------------------------------------
 *
 *   CLAME:"mapping"
 *	
 *   
 *  
 ---------------------------------------------------------------*/
#include "mapping_lite.h"



int main(int argc,char *argv[])
{

    #ifdef debug
        cout<<"CLAME version_2.1 25/09/2017"<<endl;
        cout<<"Debug enable"<<endl;
    #endif
    //struct Args {bool multiFasta; bool fastq, bool outputFile; bool numT; bool bases_Threshold; bool print; bool fm9; bool lu; bool ld; bool sizeBin;bool w;};
    Args   args = {false,false,false,false,false,false,false,false,false,false,false};
    Names  names;
    //struct Parameters {int ld; int lu; int numThreads; int query_size; bool enablePrint; bool loadFM9;int sizeBin;bool w;};
    Parameters parameters={1,10000,1,20,false,false,1000,0};
    names.outputFile="output";

    bool initOK=readArguments(argc,argv,&args,&names,&parameters);
    if (initOK)
    {
        parameters.loadFM9=args.fm9;
	parameters.enablePrint=args.print;
        bool runningError=false;
        
        vector<string> title;         //Array to hold the name of the reads
        vector<string> bases;         //Array to hold the bases of the reads
        vector<string> qual;          //Array to hold the bases of the reads' quality
        vector<uint32_t> index;       //Array to hold the bases->index assencion
        string fasta="";              //String to generate the FM-reference

        //reading the multiFasta file into vectors 
        if(args.fastq)
            runningError=readFastQFile(&names,&bases,&fasta,&index,&title,&qual);
        else
            runningError=readFasta(&names,&bases,&fasta,&index,&title);
        
        //aligment
        int numberOFreads=bases.size();
        int *queryList = new int[numberOFreads] ();
        vector <int> *MatrixList= new vector <int> [numberOFreads];
        runningError=alignemnt(&names, &parameters, &bases, &fasta, &index, queryList, MatrixList,&title);
        
       

    }
    else
        printerror(argv[0]);

    return 1;
} //fin del main





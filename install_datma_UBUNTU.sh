echo 'Installing dependencies'
cd /DATMA/tools
apt-get update -y
apt-get install libz-dev
apt-get install libboost-iostreams-dev
apt-get install build-essential cmake
apt-get install curl
apt-get install wget
apt install ant
apt-get install zlib1g-dev
apt-get install -y pkg-config libfreetype6-dev libpng-dev python-matplotlib
pip install numpy

#install BWA
apt-get install -y bwa

#install SAM Tools
apt-get install samtools

#install CheckM
pip install checkm-genome
pip install checkm-genome --upgrade --no-deps
checkm data update
echo 'End dependencies'

#Making the bin directory
mkdir tools
cd tools
mkdir bin

#Trimmomatic
wget http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-0.38.zip
unzip Trimmomatic-0.38.zip
rm Trimmomatic-0.38.zip

#SDLS-lite
echo 'Installing FM-index library'
git clone https://github.com/simongog/sdsl-lite.git
cd sdsl-lite
./install.sh
cd ..

#install selectFasta
echo 'Installing selectFasta'
wget https://github.com/andvides/selectFasta/releases/download/v1.0/selectFasta_v1.zip
unzip selectFasta_v1.zip
cd selectFasta_v1
make
cp selectFasta ../bin/
cd ..
rm selectFasta_v1.zip

#rdp-classifier
echo 'Installing rdp-classifier'
git clone https://github.com/rdpstaff/RDPTools.git
cd RDPTools/
git submodule init
git submodule update
make
cd ..

#install RAPIFILT
echo 'Installing RAPIFILT'
wget https://github.com/andvides/RAPIFILT/releases/download/v1.0/RAPIFILT_v1.zip
unzip RAPIFILT_v1.zip
cd RAPIFILT_v1
make
cp rapifilt ../bin/
cd ..
rm RAPIFILT_v1.zip

#install mergeNotCombined
echo 'Installing mergeNotCombined'
wget https://github.com/andvides/mergeNotCombined/releases/download/v1.0/mergeNotCombined_v1.zip
unzip mergeNotCombined_v1.zip
cd mergeNotCombined_v1
make
cp mergeNotCombined ../bin/
cd ..
rm mergeNotCombined_v1.zip

#install clame
echo "Installing CLAME"
wget https://github.com/andvides/CLAME/releases/download/v1.0/CLAME_v1.zip
unzip CLAME_v1.zip
cd CLAME_v1
make
cp clame ../bin/

#install mapping (SDSL installed)
echo 'Installing mapping'
cd mapping
make
cp mapping ../../bin/
cd ..

#genFm9
echo 'Installing genFM9'
cd genFm9
make
cp genFm9 ../../bin/
cd ..

#binning
echo 'Installing binning'
cd binning
make
cp binning ../../bin/
cd ..
cd ..
rm CLAME_v1.zip

#Flash
echo 'Installing Flash'
git clone https://github.com/dstreett/FLASH2.git
cd FLASH2
make
cp flash2 ../bin/flash
cd ..

#Megahit
echo 'Installing Megahit'
git clone https://github.com/voutcn/megahit.git
cd megahit
make
cp megahit ../bin/ #posiblemente toque pegar los otros binarios
cd ..

#SPAdes
echo 'Installing SPAdes'
wget http://cab.spbu.ru/files/release3.13.0/SPAdes-3.13.0.tar.gz
tar -xzf SPAdes-3.13.0.tar.gz
cd SPAdes-3.13.0
./spades_compile.sh
pwd=`pwd`
ln -s $pwd/spades.py ../bin/
cd ..
rm SPAdes-3.13.0.tar.gz

#Velvet
echo 'Installing Velvet'
git clone https://github.com/dzerbino/velvet.git
cd velvet
make
cp velvet* ../bin/
cd ..

#QUAST
echo 'Installing QUAST tool'
wget https://downloads.sourceforge.net/project/quast/quast-5.0.2.tar.gz
tar -xzf quast-5.0.2.tar.gz
cd quast-5.0.2
./setup.py install_full
cd ..
rm quast-5.0.2.tar.gz

#Prodigal
echo 'Installing Prodigal'
git clone https://github.com/hyattpd/Prodigal.git
cd Prodigal/
make
cp prodigal ../bin/
cd ..

#krona
echo 'Installing Krona'
wget https://github.com/marbl/Krona/releases/download/v2.7/KronaTools-2.7.tar
tar -xvf  KronaTools-2.7.tar
cd KronaTools-2.7/
./install.pl
./updateTaxonomy.sh
./updateAccessions.sh
cd ..
rm KronaTools-2.7.tar

#Kaiju
echo 'Installing Kaiju'
git clone https://github.com/bioinformatics-centre/kaiju.git
cd kaiju/src/
make
cd ..
read -p "Do you want to download the Kaiju database (~27GB)?: (Y/N) " ans
if [ "$ans" = 'Y' ] || [ "$ans" = 'y' ]; then
  echo "Downloading locat kaijudb"
  mkdir kaijudb
  cd kaijudb
  ../bin/makeDB.sh -r
  rm -r genomes/
  rm kaiju_db.bwt
  rm kaiju_db.faa
  rm kaiju_db.sa
  cd ..
else
  echo "You can specify the Kaiju database using the configuration file"
fi
cp bin/* ../bin/
cd ..

#Blast
echo 'Installing BLAST'
apt-get install ncbi-blast+

#update nt database
read -p "Do you want to download the NT-database (~58GB)?: (Y/N) " ans
if [ "$ans" = 'Y' ] || [ "$ans" = 'y' ]; then
  echo "Downloading locat NT"
  git clone https://github.com/jrherr/bioinformatics_scripts.git
  cp bioinformatics_scripts/perl_scripts/update_blastdb.pl bin/
  chmod +x bin/update_blastdb.pl
  cd ../
  mkdir blastdb
  cd blastdb
  perl ../tools/bin/update_blastdb.pl --passive --decompress nt
  cd ..
else
  echo "You can specify a local NT-database using the configuration file"
fi

#FINISH
echo 'Updating the PATH to include the tools'
pwd=`pwd`
export PATH=$pwd/bin/:$PATH
echo 'DATMA INSTALLED'
cd ..

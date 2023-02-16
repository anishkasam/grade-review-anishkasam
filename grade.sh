CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

rm -rf student-submission
git clone $1 student-submission
echo 'Finished cloning'

cd student-submission

if [[ -e ListExamples.java ]]
then
    echo 'ListExamples.java found'
else
    echo 'Error ListExamples.java not found'
    exit
fi

mkdir lib
cd ..
cp TestListExamples.java student-submission/
cp lib/* student-submission/lib
cd student-submission

javac -cp $CPATH *.java 2> output.txt
if [[ $? > 0 ]] 
then
    cat output.txt
    exit
fi

java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > tests.txt
if grep -q -e "OK" tests.txt 
then   
    echo '100%'
else
    TOTAL=`tail -2 tests.txt | xargs | cut -d "," -f 1 | cut -d ":" -f 2 | xargs`
    FAILS=`tail -2 tests.txt | xargs | cut -d "," -f 2 | xargs | cut -d ":" -f 2 | xargs`

    RATIO=`expr $TOTAL - $FAILS / $TOTAL`
    echo `expr $RATIO \* 100`"%"
fi
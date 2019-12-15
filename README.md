# tensorflow-notebook
This project describes a Docker image based on jupyter/tensorflow-notebook attached to an Azure HDInsight Spark Cluster.

Define the following environment variables...
USERNAME - Azure HDInsight defaults this to admin
BASE64ENCODEDPASSWORD - The base64 encoded password to the HDInsight Spark Cluster
CLUSTERDNSNAME - The FQDN of the Spark Cluster (e.g. myCluster.azurehdinsight.net)

Then run the following commands...
docker build -t tensorflow-notebook .
docker run -it -e USERNAME=$USERNAME -e BASE64ENCODEDPASSWORD=$BASE64ENCODEDPASSWORD -e CLUSTERDNSNAME=$CLUSTERDNSNAME -p 8888:8888 tensorflow-notebook

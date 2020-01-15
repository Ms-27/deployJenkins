#!/bin/bash
tomcat_install(){
	if [[ -e apache-tomcat-7.0.75.tar.gz ]]
	then
		tar -zxf apache-tomcat-7.0.75.tar.gz --directory ~/
	else
		echo "fichier tomcat non présent"
	fi

	if [[ -d /opt/apache-tomcat-7.0.75 ]]
	then
		echo "archive tomcat bien décompressée"
	fi

# on test la présence de java
	dpkg -s default-jdk | grep Status
	if [ $? -gt  0 ]
	then
# si il n'est pas présent on l'installe
		apt-get install default-jdk
		echo "jdk a bien été installé"
	else
		echo "java est déjà installé"
	fi

# on définit les variables d'environements dan le bashrc et on le source
	echo "JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64" >> ~/.bashrc 
	echo "CATALINA_HOME=/opt/tomcat/apache-tomcat-7.0.75" >> ~/.bashrc
	source ~/.bashrc
}

jenkins_install(){
	if [[ -e jenkins46.war ]]
	then
		cp jenkins46.war ~/apache-tomcat-7.0.75/webapps/
	else
		echo "fichier jenkins non présent"
	fi
}

# on vérifie si tomcat est présent
# variante à supprimer : test_tomcat="ls /opt | grep tomcat | wc -l"
if [[ -d /opt/tomcat/ ]]
then
	echo "tomcat déjà présent"
else
	echo "on installe tomcat"
	tomcat_install
fi

#jenkins_install

# on vérifie si tomcat est lancé
#test="service tomcat7 status | grep "No" | awk '{print $2}'"

#if [[ $test =~ "not-found" ]]
#then
#	echo "Ok"
#else
#	echo "KO"
#fi
